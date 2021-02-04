### 城市数据的分组排序

使用 [BMChineseSort](https://github.com/Baymax0/BMChineseSort) 框架进行分组排序。

```objc
- (void)setupCityData {
    // 从本地加载热门城市数据
    HQLPropertyListStore *hotCityStore = [[HQLPropertyListStore alloc] initWithJSONFileName:KHotCityJSONFileName modelsOfClass:[HQLCity class]];
    self.hotCities = hotCityStore.dataSourceArray;
    
    // 从本地加载城市数据
    HQLPropertyListStore *cityStore = [[HQLPropertyListStore alloc] initWithJSONFileName:KCityJSONFileName modelsOfClass:[HQLCity class]];
    self.cities = cityStore.dataSourceArray;
    
    // 对城市数据进行分组排序
    __weak __typeof(self)weakSelf = self;
    [BMChineseSort sortAndGroup:self.cities key:@"first_char" finish:^(bool isSuccess, NSMutableArray *unGroupedArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        // 在数据源中添加「当前城市」、「热门城市」
        if (isSuccess) {
            // 城市索引
            [sectionTitleArr insertObject:@"热门" atIndex:0];
            [sectionTitleArr insertObject:@"当前" atIndex:0];
            strongSelf.indexNames = [sectionTitleArr copy];
            
            // 城市数据
            NSMutableArray *nullArray = [NSMutableArray arrayWithObject:[NSNull null]];
            [sortedObjArr insertObject:nullArray atIndex:0];
            [sortedObjArr insertObject:nullArray atIndex:0];
            strongSelf.groupedCities = [sortedObjArr copy];
            
            [strongSelf.tableView reloadData];
        }
    }];
}
```

这里的 json 数据源是包含城市数据模型的数组，所以分组显示之前需要执行分组排序处理。

你也可以将城市数据提前分组排序好，并保存为 json 数据，这样就可以直接加载使用了。



### 中文搜索

中文搜索使用 [ZYPinYinSearch](https://github.com/bjzhangyang/ZYPinYinSearch) 框架。

```objc
#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = self.searchController.searchBar.text;
    
    if (searchText.length > 0) {
        __weak __typeof(self)weakSelf = self;
        [ZYPinYinSearch searchByPropertyName:@"name" withOriginalArray:self.cities searchText:searchText success:^(NSArray *results) {
            weakSelf.searchResultController.searchResultCities = results;
        } failure:^(NSString *errorMessage) {
            weakSelf.searchResultController.searchResultCities = nil;
        }];
    }
}
```



简单搜索方案，对待搜索字符串执行 `lowercaseString` 操作，判断城市模型中属性是否包含待搜索字符串。

```objc
-(void)setYm_searchText:(NSString *)ym_searchText{
    _ym_searchText = ym_searchText;
    ym_searchText = [ym_searchText copy];
    // 将待搜索字符串小写化
    ym_searchText = ym_searchText.lowercaseString;
    // 清空上一次的搜索结果
    [_ym_resultArray removeAllObjects];
    for (YMCityModel *cityModel in _ym_cityArray) {
        // 判断城市模型属性中是否包含该字段
        if ([cityModel.name containsString:ym_searchText] || [cityModel.pinYin containsString:ym_searchText] || [cityModel.pinYinHead containsString:ym_searchText]) {
            [_ym_resultArray addObject:cityModel];
        }
    }
  
    // 重新加载搜索结果
    [self.tableView reloadData];
}
```



### 其他开源示例代码

* [YMCitySelect](https://github.com/EamonJoy/YMCitySelect)
* [CityList](https://github.com/houshixian/CityList)


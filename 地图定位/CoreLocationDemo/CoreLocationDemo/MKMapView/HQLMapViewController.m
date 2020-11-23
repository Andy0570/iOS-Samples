//
//  HQLMapViewController.m
//  CoreLocationDemo
//
//  Created by Qilin Hu on 2020/11/23.
//

#import "HQLMapViewController.h"

// Framework
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <JKCategories/UIView+JKToast.h>

// Model
#import "HQLAnnotation.h"

@interface HQLMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate>

// 目标位置坐标
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

// 当前位置坐标
@property (nonatomic, assign) double myLatitude;
@property (nonatomic, assign) double myLongitude;

@property (nonatomic, strong) CLLocationManager *locationManager; // 定位管理器
@property (nonatomic, strong) MKMapView *mapView; // 地图
@property (nonatomic, strong) CLGeocoder *geocoder; // 地理编码
@property (nonatomic, copy) NSString *string; // 两点之间的距离
@property (nonatomic, strong) MKDirections *directions; // 路径桂湖

@end

@implementation HQLMapViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupMapView];
    [self setupLocation];
    [self setupGeocoder];
}

/// 初始化导航栏
- (void)setupNavigationBar {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(navigationButtonAction:)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"规划路线" style:UIBarButtonItemStylePlain target:self action:@selector(geocodeButtonAction:)];
    self.navigationItem.rightBarButtonItems = @[leftItem, rightItem];
}

/// 初始化地图
- (void)setupMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.mapType = MKMapTypeStandard; // 地图类型
    self.mapView.showsCompass = YES; // 显示指南针
    self.mapView.showsScale = YES; // 显示比例尺
    self.mapView.showsUserLocation = YES; // 显示用户所在的位置
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
//    // 其他属性
//    // 显示感兴趣的东西，API_DEPRECATED
//    self.mapView.showsPointsOfInterest = YES;
//    // 定义显示的 span 范围
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.01;
//    span.longitudeDelta = 0.01;
//    // 定义显示的 region 区域
//    MKCoordinateRegion region;
//    region.center = (CLLocationCoordinate2D)theCoordinate2D;
//    region.span = span;
//    // 显示交通状况
//    self.mapView.showsTraffic = YES;
//    // 显示建筑物
//    self.mapView.showsBuildings = YES;
}

/// 初始化系统定位
- (void)setupLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        // 可以定位
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        // 设置定位精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置距离
        self.locationManager.distanceFilter = 50;
        // 申请定位权限，iOS 8 之后可以用
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        // 开始定位
        [self.locationManager startUpdatingHeading];
    } else {
        [self.view jk_makeToast:@"定位服务未开启"];
    }
}

// 初始化地理编码
- (void)setupGeocoder {
    self.geocoder = [[CLGeocoder alloc] init];
    
    // 获取目标位置，计算并标注两点之间的距离
    [self geocodeAddressWithDestinationAddress:@"江苏省无锡市国家工业设计知识产权园"];
}

// MARK: 地理编码：根据位置名称转换经纬度
- (void)geocodeAddressWithDestinationAddress:(NSString *)destination {
    [self.geocoder geocodeAddressString:destination completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%s:%@",__PRETTY_FUNCTION__, error.localizedDescription);
            [self.view jk_makeToast:[NSString stringWithFormat:@"地理编码错误：%@",error.localizedDescription]];
        } else {
            NSLog(@"CLPlacemark: \n%@", placemarks);
            
            [placemarks enumerateObjectsUsingBlock:^(CLPlacemark * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSLog(@"目标位置: %@，坐标: (%f, %f)",obj.name, obj.location.coordinate.latitude, obj.location.coordinate.longitude);
                
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = obj.location.coordinate.latitude;
                coordinate.longitude = obj.location.coordinate.longitude;
                
                self->_latitude = obj.location.coordinate.latitude;
                self->_longitude = obj.location.coordinate.longitude;
                
                // 计算两个坐标之前的位置
                CLLocation *location1 = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
                CLLocation *location2 = [[CLLocation alloc] initWithLatitude:self.myLatitude longitude:self.myLongitude];
                float distance = [location1 distanceFromLocation:location2];
                NSLog(@"distance: %f", distance);
                
                self.string = [NSString stringWithFormat:@"距离:%.3fkm", distance/1000];
                
                // 添加大头针
                [self addAnnotationWithPoint:coordinate];
            }];
        }
    }];
}

// MARK: 反地理编码：根据经纬度，获取位置信息
- (void)reverseGeocodeWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%s:%@",__PRETTY_FUNCTION__, error.localizedDescription);
            [self.view jk_makeToast:[NSString stringWithFormat:@"反地理编码错误：%@",error.localizedDescription]];
        } else {
            NSLog(@"placemarks: %@", placemarks);
            [placemarks enumerateObjectsUsingBlock:^(CLPlacemark * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"名称：%@", obj.name);
            }];
        }
    }];
}

// 添加大头针
- (void)addAnnotationWithPoint:(CLLocationCoordinate2D)location {
    HQLAnnotation *annotation = [[HQLAnnotation alloc] init];
    annotation.coordinate = location;
    annotation.title = self.string;
    annotation.subtitle = @"当前位置";
    [self.mapView addAnnotation:annotation];
}

#pragma mark - Actions

// MARK: 打开第三方地图导航
- (void)navigationButtonAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 系统地图
    UIAlertAction *systemMapAction = [UIAlertAction actionWithTitle:@"系统地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *destinationLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude) addressDictionary:nil]];
        
        NSDictionary *launchOptions = @{
            MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]
        };
        [MKMapItem openMapsWithItems:@[currentLocation, destinationLocation] launchOptions:launchOptions];
    }];
    [alert addAction:systemMapAction];
    
    // 高德地图
    BOOL isInstallGaodeMap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
    if (isInstallGaodeMap) {
        UIAlertAction *gaodeMapAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2", self.latitude, self.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        }];
        [alert addAction:gaodeMapAction];
    }
    
    // 百度地图
    BOOL isInstallBaiduMap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
    if (isInstallBaiduMap) {
        UIAlertAction *baiduMapAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02", self.latitude, self.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        }];
        [alert addAction:baiduMapAction];
    }
    
    // 取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 规划路线
- (void)geocodeButtonAction:(id)sender {
    // 根据位置名称转换经纬度
    
    // 地理编码：根据位置名称获取「起点」坐标经纬度
    [self.geocoder geocodeAddressString:@"江苏省无锡市国家工业设计知识产权园" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:placemarks.lastObject]];
        MKCoordinateRegion region = MKCoordinateRegionMake(source.placemark.location.coordinate, MKCoordinateSpanMake(0.02, 0.02));
        [self.mapView setRegion:region];
        
        // 地理编码：根据位置名称获取「终点」坐标经纬度
        [self.geocoder geocodeAddressString:@"江苏省无锡三国水浒景区" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:placemarks.lastObject]];
            
            // 发出请求
            [self moveForm:source toDestination:destination];
        }];
    }];
}

#pragma mark - CLLocationManagerDelegate 定位管理器

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // 获取当前定位
    CLLocation *currentLocation = locations.lastObject;
    NSLog(@"当前定位：%@", currentLocation.description);
    
    CLLocationCoordinate2D currentCoordinate;
    currentCoordinate.latitude = currentLocation.coordinate.latitude; // 纬度
    currentCoordinate.longitude = currentLocation.coordinate.longitude; // 经度
    
    // 添加大头针
    [self addAnnotationWithPoint:currentCoordinate];
    
    // 保存当前定位
    _myLatitude = currentLocation.coordinate.latitude;
    _myLongitude = currentLocation.coordinate.longitude;
    
    // 定义显示的 span 范围
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta = 0.01;
    theSpan.longitudeDelta = 0.01;
    
    // 定义显示的区域
    MKCoordinateRegion currentRegion;
    currentRegion.center = currentCoordinate;
    currentRegion.span = theSpan;
    
    // 更新当前定位区域到地图
    [self.mapView setRegion:currentRegion];
}

// 定位失败
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self.view jk_makeToast:@"定位失败..."];
}

// 更新方向
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    
}

// 用于判断是否显示方向的校对，返回 yes 的时候，将会校对正确之后才会停止
// 或者 dismissheadingcalibrationdisplay 方法解除。
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

#pragma mark - MKMapViewDelegate

// 一个位置更改，默认只会调用一次，不断监测用户的当前位置
// 每次调用，都会把用户的最新位置（userLocation参数）传进来
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    userLocation.title = @"现在位置";
    
    CLLocationCoordinate2D currentCoordinate;
    currentCoordinate.latitude = userLocation.coordinate.latitude; // 纬度
    currentCoordinate.longitude = userLocation.coordinate.longitude; // 经度
    [self.mapView setCenterCoordinate:currentCoordinate animated:YES];
    NSLog(@"用户定位:%f,%f",userLocation.coordinate.latitude, userLocation.coordinate.longitude);
}

// 地图的显示区域即将发生改变的时候调用
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
}

// 地图的显示区域已经发生改变的时候调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
}

// 设置大头针
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // 判断大头针位置是否在原点，如有是，则不加大头针
    if ([annotation isKindOfClass:mapView.userLocation.class]) {
        return nil;
    }
    
    static NSString *identifier = @"pappao";
    MKAnnotationView *pin = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!pin) {
        pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    pin.annotation = annotation;
    pin.canShowCallout = YES; // 设置是否弹出标注
    pin.image = [UIImage imageNamed:@"map"];
    pin.draggable = YES;
    
    // 弹出视图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 25)];
    imageView.image = [UIImage imageNamed:@"map1"];
    pin.leftCalloutAccessoryView = imageView;
    
    return pin;
}

#pragma mark - 触摸手势

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    // 1. 获取当前触摸点
//    CGPoint point = [[touches anyObject] locationInView:self.mapView];
//    // 2. 转换成经纬度
//    CLLocationCoordinate2D location = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
//    // 3. 添加大头针
//    [self addAnnotationWithPoint:location];
//
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    // 移除大头针(模型)
//    NSArray *annos = self.mapView.annotations;
//    [self.mapView removeAnnotations:annos];
//}

#pragma mark - 路径规划

// 提供两个点的坐标，规划路径
- (void)moveForm:(MKMapItem *)source toDestination:(MKMapItem *)destination {
    // 创建请求
    // 创建请求体（起点与终点）
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    self.directions = [[MKDirections alloc] initWithRequest:request];
    
    // 计算路径规划信息（向服务器发请求）
    [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        // 获取到所有路线
        NSArray <MKRoute *> *routes = response.routes;
        // 取出最后一条路线
        MKRoute *route = routes.lastObject;
        
        // 遍历路线中的每一步，添加到地图上
        [route.steps enumerateObjectsUsingBlock:^(MKRouteStep * _Nonnull step, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.mapView addOverlay:step.polyline];
        }];
    }];
}

// 返回指定的遮罩模型所对应的遮盖视图，renderer-渲染
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    // 判断类型
    if ([overlay isKindOfClass:MKPolyline.class]) {
        // 针对线段，系统有提供好的遮盖视图
        MKPolylineRenderer *lineRender = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        
        // 配置遮盖线条的颜色
        lineRender.lineWidth = 5;
        lineRender.strokeColor = UIColor.lightGrayColor;
        return lineRender;
    } else {
        return nil;
    }
}

@end

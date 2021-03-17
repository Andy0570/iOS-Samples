## Tangram 基础架构

Tangram 模块：



![](https://img.alicdn.com/tfs/TB12wRPQpXXXXadXVXXXXXXXXXX-658-383.png)

Tangram 执行流程：

![](https://img.alicdn.com/tfs/TB1.9BOQpXXXXacXVXXXXXXXXXX-779-281.png)





# Layout Index - 布局索引

[官方文档：内置布局支持](http://tangram.pingguohe.net/docs/layout-support/inner-support)

Type is a layout property in JSON

 ![](https://img.alicdn.com/tfs/TB1o426PVXXXXb_XXXXXXXXXXXX-445-241.png)

## FlowLayout - 流式布局

![](https://img.alicdn.com/tfs/TB1UX3DPVXXXXbsXXXXXXXXXXXX-548-299.png)

|type|Description|
|---|----|
|1|One column 一排一列|
|2|Two columns 一排两列|
|3|Three columns 一排三列|
|4|Four columns 一排四列|
|9|Five columns 一排五列|
|27|any column,assign by code or style in JSON|


## 1-n layout (n=2/3/4)  - 1拖N布局

A large element on the left ，several small element on the right，support assiging ratio of the left and right.

![](https://img.alicdn.com/tfs/TB1UmkEPVXXXXbDXXXXXXXXXXXX-559-239.png)

There are three styles of the layout：

* A large element on the left，one above one below on the right.（左边一个，右边上面一个下面一个）
* A large element on the left，one above two below on the right.（左边一个，右边上面一个下面两个
）
* A large element on the left，one above three below on the right.（左边一个，右边上面一个下面三个
）

Adjust depend on the count of itemModels in the layout

|type|Description|
|---|----|
|5|One Drag N(N=2/3/4)|

## Drag Layout - 浮标布局

The layout can be dragged, auto hit to edges，可拖动，自动吸边

The No.0 element is in a drag layout.

![](https://img.alicdn.com/tfs/TB1Nv3DPVXXXXcaapXXXXXXXXXX-370-672.gif)

|type|Description|
|---|----|
|7|Drag Layout|

## Fix Layout - 悬浮布局

Fix at fixed position, or scroll to some position to show

The No.0 element is in a fix layout.

![](https://img.alicdn.com/tfs/TB1tOUDPVXXXXcnaXXXXXXXXXXX-370-672.gif)

|type|Description|
|---|----|
|8|Fix at top|
|23|Fix at bottom|
|28|Scroll to some layout to show and fix at top) 滚动固定 (滚动到某个布局的时候，出现并固定)|

## Sticky Layout - 吸顶布局

If the layout hit the top of visible area, it will stick to top edge of visible area.

The No.9 element is in a sticky layout

![](https://img.alicdn.com/tfs/TB1tOUDPVXXXXcnaXXXXXXXXXXX-370-672.gif)

|type|Description|
|---|----|
|21|Stick to top|

## Page Scroll Layout - 轮播布局

Suitable for banner, it can auto scrolling , cycle scrolling or linear scrolling

![](https://img.alicdn.com/tps/TB1WOUsOpXXXXbzXFXXXXXXXXXX-373-90.gif)

|type|Description|
|---|----|
|10|Page Scroll Layout|

## Water Flow Layout - 瀑布流布局

![](https://img.alicdn.com/tfs/TB1tDEJPVXXXXXWaXXXXXXXXXXX-375-689.png)

|type|Description|
|---|----|
|25|WaterFlow Layout|



### 一个布局的 JSON 描述示例

```json
{
"type": "container-oneColumn", ---> 描述布局类型
"style": { ---> 描述样式
  ...
},
"header": { ---> 描述header
},
"items": [ ---> 描述组件列表
  ...
],
"footer": { ---> 描述footer
}
}
```



### 一个组件的 JSON 描述示例

```json
{
"type": "demo", ---> 描述组件类型
"style": { ---> 描述组件样式
  "margin": [
    10,
    10,
    10,
    10
  ],
  "height": 100,
  "width": 100
}
"imgUrl": "[URL]", ---> 业务数据
"title": "Sample"
}
```







## 组件的基础模型

基础组件、原子组件、容器组件的属性：

[参考](http://tangram.pingguohe.net/docs/virtualview/elements)

| 名称               | 类型                                          | 默认值    | 描述                                                         |
| ------------------ | --------------------------------------------- | --------- | ------------------------------------------------------------ |
| id                 | int                                           | 0         | 组件 id                                                      |
| layoutWidth        | int/float/enum(match_parent/wrap_content)     | 0         | 组件的布局宽度，与 Android 里的概念类似，<br>写绝对值的时候表示绝对宽高，<br/>match_parent 表示尽可能撑满父容器提供的宽高，<br/>wrap_content 表示根据自身内容的宽高来布局 |
| layoutHeight       | int/float/enum(match_parent/wrap_content)     | 0         | 组件的布局宽度，与 Android 里的概念类似，<br/>写绝对值的时候表示绝对宽高，<br/>match_parent 表示尽可能撑满父容器提供的宽高，<br/>wrap_content 表示根据自身内容的宽高来布局 |
| layoutGravity      | enum(left/right/top/bottom/v_center/h_center) | eft\|top  | 描述组件在容器中的对齐方式，<br/>left：靠左，right：靠右，top：靠上，bottom：靠底，v_center：垂直方向居中，h_center：水平方向居中，可用`或`组合描述 |
| autoDimX           | int/float                                     | 1         | 组件宽高比计算的横向值                                       |
| autoDimY           | int/float                                     | 1         | 组件宽高比计算的竖向值                                       |
| autoDimDirection   | enum(X/Y/NONE)                                | NONE      | 组件在布局中的基准方向，<br/>用于计算组件的宽高比，与 autoDimX、autoDimY 配合使用，设置了这三个属性时，在计算组件尺寸时具有更高的优先级。<br/>当 autoDimDirection=X 时，组件的宽度由 layoutWidth 和父容器决策决定，但高度 = width * (autoDimY /autoDimX)，<br/>当 autoDimDirection=Y 时，组件的高度由 layoutHeight 和父容器决策决定，但宽度 = height * (autoDimX /autoDimY) |
| minWidth           | int/float                                     | 0         | 最小宽度                                                     |
| minHeight          | int/float                                     | 0         | 最小高度                                                     |
| paddingLeft        | int/float                                     | 0         | 左内边距                                                     |
| paddingRight       | int/float                                     | 0         | 右内边距                                                     |
| paddingTop         | int/float                                     | 0         | 上内边距                                                     |
| paddingBottom      | int/float                                     | 0         | 下内边距                                                     |
| layoutMarginLeft   | int/float                                     | 0         | 左外边距                                                     |
| layoutMarginRight  | int/float                                     | 0         | 右外边距                                                     |
| layoutMarginTop    | int/float                                     | 0         | 上外边距                                                     |
| layoutMarginBottom | int/float                                     | 0         | 下外边距                                                     |
| background         | int                                           | 0         | 背景色                                                       |
| backgroundImage    | string                                        | null      | 背景图地址                                                   |
| borderWidth        | int                                           | 0         | 边框宽度                                                     |
| borderColor        | int                                           | 0         | 边框颜色                                                     |
| visibility         | enum(visible/invisible/gone)                  | visible   | 可见性，与 Android 里的概念类似，<br/>visible：可见，invisible：不可见，但占位，gone：不可见也不占位 |
| gravity            | enum(left/right/top/bottom/v_center/h_center) | left\|top | 描述内容的对齐，比如文字在文本组件里的位置、原子组件在容器里的位置，<br/>left：靠左，right：靠右，top：靠上，bottom：靠底，v_center：垂直方向居中，h_center：水平方向居中，可用`或`组合描述 |



方案内内置了一系列基础组件，完整的组件列表如下：

* 虚拟文本组件
* 原生文本组件
* 虚拟图片组件
* 原生图片组件
* 虚拟线条组件
* 原生线条组件
* 虚拟进度条组件
* 虚拟图形组件
* 原生翻页布局容器组件
* 原生滚动布局容器组件
* 虚拟帧布局容器组件
* 虚拟比例布局容器组件
* 虚拟网格布局容器组件
* 原生网格布局容器组件
* 虚拟线性布局容器组件
* 原生线性布局容器组件










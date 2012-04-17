[global-info] -->全局设置，必须放第一块
script_watch_interval=-1 --> -1为自动计算间隔，正数为间隔数，单位秒
script_state=sleeping...  -->自动生成
script_nexttime=2012/04/17 17:47:00  -->自动生成，下次查看时间

[http://test.thi-group.com.cn/task.php?ac=erp_sailing_sync]  -->访问的地址
execution=y  -->是否开启
interval=0,5  -->间隔数 秒,分,时,天    0,5表示0秒5分   0,0,0,1表示1天
nexttime=2012/04/17 17:46:59  -->自动生成，此url下次运行时间
state=stop  -->当前状态

[http://other.url]  -->访问的地址
execution=y  -->是否开启
interval=0,5  -->间隔数 秒,分,时,天    0,5表示0秒5分   0,0,0,1表示1天
nexttime=2012/04/17 17:46:59  -->自动生成，此url下次运行时间
state=stop  -->当前状态
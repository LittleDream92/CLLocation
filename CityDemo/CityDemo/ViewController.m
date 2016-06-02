//
//  ViewController.m
//  CityDemo
//
//  Created by Meng Fan on 16/5/31.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self locate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)locate {
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        if (!_locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
            }
        }
        
        //设置代理
        [self.locationManager setDelegate:self];
        //设置定位精度
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //设置距离筛选
        [self.locationManager setDistanceFilter:100];
        //开始定位
        [self.locationManager startUpdatingLocation];
        //设置开始识别方向
        [self.locationManager startUpdatingHeading];

    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"您没有开启定位功能"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}


#pragma mark CoreLocation delegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    
    //反编码
    [self reverseGeocoder:currentLocation];
}


#pragma mark - 反编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            NSLog(@"error == %@", error);
        }else {
            CLPlacemark *placemark = placemarks.firstObject;
            NSLog(@"placemarks:%@", [[placemark addressDictionary] objectForKey:@"City"]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的位置" message:[[placemark addressDictionary] objectForKey:@"City"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
}



@end

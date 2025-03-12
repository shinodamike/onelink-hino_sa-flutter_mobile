import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get dashboardTab1;

  String get dashboardTab2;

  String get dashboardGraph1;

  String get dashboardGraph2;

  String get dashboardGraph3;

  String get status_last;

  String get my_vehicle;

  String get total;

  String get my_driver;

  String get my_driver_total;

  String get unit_driver;

  String get driving;

  String get ignOff;

  String get idle;

  String get offline;

  String get over_speed;

  String get swipe_card;

  String get wrong_license;

  String get expire_card;

  String get no_swipe_card;

  String get avg;

  String get score;

  String get unit;

  String get select_lang;

  String get km_h;

  String get h;

  String get start_date;

  String get end_date;

  String get select_all;

  String get backBtn;

  String get total_vehicle;

  String get info_map;

  String get overspeed_info;

  String get vehicle_group;

  String get rpm_red;

  String get rpm_green;

  String get search;

  String get sort;

  String get filter;

  String get vehicle_list;
  String get geofence_des;
  String get geofence_location;
  String get geofence_unit;
  String get driver_title;
  String get driver;
  String get location_title;
  String get last_update;
  String get location;
  String get station;
  String get status_vehicle;
  String get mile;
  String get distance;
  String get fuel;
  String get km;
  String get gps;
  String get gsm;
  String get dtc_engine;
  String get on;
  String get off;
  String get unidentified_driver;
  String get license;
  String get vehicle_title;
  String get plate_no;
  String get vin_no;
  String get model;
  String get maintenance;
  String get insurance;
  String get tires_service;
  String get next_service;
  String get event_log;
  String get tracking_history;
  String get cctv_playback;
  String get camera_playback;
  String get search_by;
  String get date_range;
  String get time_range;
  String get vehicle_name;
  String get please_select;
  String get lite;
  String get km_l;
  String get event_driving;
  String get event_ign_off;
  String get event_date_time;
  String get event_duration;
  String get event_obd_start;
  String get event_obd_end;
  String get event_distance;
  String get event_fuel;
  String get event_fuel_consumption;
  String get event_driver;
  String get more;
  String get less;

  String get driver_distance;
  String get driver_duration;

  String get username;
  String get password;
  String get signin;
  String get forgot_password;

  String get dlt_regulation;
  String get driving_behavior;
  String get unit_times;
  String get noti_event;
  String get noti_vehicle;
  String get noti_driver;

  String get noti_date;
  String get noti_location_title;
  String get noti_location;

  String get sign_out;
  String get notification;

  String get email_phone;
  String get confirm;
  String get otp;
  String get confirm_password;
  String get reset_filter;
  String get speed;
  String get status;
  String get sort_by;
  String get unit_descending;
  String get unit_ascending;
  String get alphabet_a_z;
  String get alphabet_z_a;

  String get option;
  String get option_total;
  String get snapshot;
  String get temperatures;
  String get door;
  String get safety_belt;
  String get mvdr;
  String get score_asc;
  String get score_dec;
  String get swipe_time;
  String get loading;
  String get please_try_again;
  String get fuel_km;
  String get chart_vehicle_working;
  String get vehicle_model;
  String get period;
  String get dealer;
  String get current_location;
  String get driving_summary_time;
}

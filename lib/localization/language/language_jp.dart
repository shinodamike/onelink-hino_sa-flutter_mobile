import 'languages.dart';

class LanguageJp extends Languages {

  String get appName => "iOV";

  @override
  String get dashboardTab1 => "サマリー";
  @override
  String get dashboardTab2 => "リアルタイムステータス";
  @override
  String get dashboardGraph1 => "車両使用率";
  @override
  String get dashboardGraph2 => "ECO運転サマリー";
  @override
  String get dashboardGraph3 => "安全運転サマリー";
  @override
  String get status_last => "リアルタイムステータス";
  @override
  String get my_vehicle => "管理車両情報";
  @override
  String get total => "合計";
  @override
  String get my_driver => "ドライバー情報";
  @override
  String get my_driver_total => "ドライバー情報";
  @override
  String get unit_driver => "人";
  @override
  String get driving => "走行中";
  @override
  String get ignOff => "Ign. OFF";
  @override
  String get idle => "アイドリング";
  @override
  String get offline => "オフライン";
  @override
  String get over_speed => "速度超過";
  @override
  String get swipe_card => "免許証 認証済み";
  @override
  String get wrong_license => "免許証タイプが一致しませんでした";
  @override
  String get no_swipe_card => "免許証が未認証";
  @override
  String get avg => "フリートスコア\n平均";
  @override
  String get score => "スコア";
  @override
  String get unit => "台";

  @override
  String get select_lang => "言語を変えてください";
  @override
  String get km_h => "km/h";
  @override
  String get h => "h";
  @override
  String get start_date => "Start Date";
  @override
  String get end_date => "End Date";
  @override
  String get select_all => "すべて選択";
  @override
  String get backBtn => "戻る";

  @override
  String get total_vehicle => "合計";
  @override
  String get info_map => "地図情報";
  @override
  String get overspeed_info => "60km/h以上の速度超過";
  @override
  String get vehicle_group => "車両グループ";
  @override
  String get rpm_red => "E/G回転数レッドゾーン";
  @override
  String get rpm_green => "E/G回転数オーバーグリーンゾーン";

  @override
  String get search=> "検索";
  @override
  String get sort=> "選別";
  @override
  String get filter=> "フィルター";
  @override
  String get vehicle_list=> "車両リスト";
  @override
  String get geofence_des=> "ジオフェンスの説明";
  @override
  String get geofence_location=> "位置";
  @override
  String get geofence_unit=> "総車両";
  @override
  String get driver_title=> "ドライバー";
  @override
  String get driver=> "ドライバー名";
  @override
  String get location_title=> "位置";
  @override
  String get last_update=> "最後の更新";
  @override
  String get location=> "位置";
  @override
  String get station=> "駅";
  @override
  String get status_vehicle=> "スターテス";
  @override
  String get mile=> "ODO";
  @override
  String get distance=> "ODO (Today)";
  @override
  String get fuel=> "燃料タンク残量";
  @override
  String get km=> "km";
  @override
  String get gps=> "GPS信号";
  @override
  String get gsm=> "3G回線";
  @override
  String get dtc_engine=> "E/Gチェックランプ";
  @override
  String get on=> "On";
  @override
  String get off=> "Off";
  @override
  String get unidentified_driver=> "ドライバー情報がありません";
  @override
  String get license=> "ナンバープレート";

  @override
  String get vehicle_title=> "車両";
  @override
  String get plate_no=> "ナンバープレート";
  @override
  String get vin_no=> "VIN No.";
  @override
  String get model=> "車型";
  @override
  String get maintenance=> "メンテナンス";
  @override
  String get insurance=> "保険";
  @override
  String get tires_service=> "タイヤサービス";
  @override
  String get next_service=> "次回メンテナンス";

  @override
  String get event_log=> "ロガーデータ";
  @override
  String get tracking_history=> "車両軌跡";
  @override
  String get cctv_playback=> "再生";
  @override
  String get camera_playback=> "Picture Playback";
  @override
  String get search_by=> "で検索";
  @override
  String get date_range=> "日付範囲";
  @override
  String get time_range=> "時間範囲";
  @override
  String get vehicle_name=> "車両名";
  @override
  String get please_select=> "";
  @override
  String get lite=> "L";
  @override
  String get km_l=> "km/L";
  @override
  String get event_driving=> "走行中";
  @override
  String get event_ign_off=> "Ign. OFF";
  @override
  String get event_date_time=> "Start Date/End Date";
  @override
  String get event_duration=> "期間";
  @override
  String get event_obd_start=> "ODOの開始";
  @override
  String get event_obd_end=> "終了ODO";
  @override
  String get event_distance=> "距離";
  @override
  String get event_fuel=> "燃料消費量";
  @override
  String get event_fuel_consumption=> "燃費";
  @override
  String get event_driver=> "ドライバー";
  @override
  String get more=> "More";
  @override
  String get less=> "Less";
  @override
  String get expire_card=> "有効期限カード";
  @override
  String get driver_distance=> "総走行距離";
  @override
  String get driver_duration=> "働時間";

  @override
  String get username=> "ユーザー名";
  @override
  String get password=> "パスワード";
  @override
  String get signin=> "ログインする";
  @override
  String get forgot_password=> "パスワードをお忘れですか?";
  @override
  String get dlt_regulation=> "DLT規制 (回数)";
  @override
  String get driving_behavior=> "運転挙動 (回)";
  @override
  String get unit_times=> "回";
  @override
  String get noti_event=> "イベント";
  @override
  String get noti_vehicle=> "車両";
  @override
  String get noti_driver=> "ドライバー";
  @override
  String get noti_date=> "日にち";
  @override
  String get noti_location_title=> "位置";
  @override
  String get noti_location=> "位置";
  @override
  String get sign_out=> "ログアウト";
  @override
  String get notification=> "通知";
  @override
  String get email_phone=> "メールまたは電話番号";
  @override
  String get confirm=> "確認";
  @override
  String get otp=> "OTP";
  @override
  String get confirm_password=> "パスワードを認証する";
  @override
  String get reset_filter=> "フィルタをリセット";
  @override
  String get speed=> "車速";
  @override
  String get status=> "スターテス";
  @override
  String get sort_by=> "Sort by";
  @override
  String get unit_descending=> "Unit Descending";
  @override
  String get unit_ascending=> "Unit Ascending";
  @override
  String get alphabet_a_z=> "Alphabet A-Z";
  @override
  String get alphabet_z_a=> "Alphabet Z-A";
  @override
  String get option=> "オプション";
  @override
  String get option_total=> "すべて";
  @override
  String get snapshot=> "スナップショット";
  @override
  String get temperatures=> "温度";
  @override
  String get door=> "車のドア";
  @override
  String get safety_belt=> "安全ベルト";
  @override
  String get mvdr=> "ビデオ";

  @override
  String get score_asc=> "Score Ascending";
  @override
  String get score_dec=> "Score Descending";
  @override
  String get swipe_time=> "Swipe time";
  @override
  String get loading=> "Please Wait";
  @override
  String get please_try_again=> "Please try again";
  @override
  String get fuel_km=> "燃費";
  @override
  String get chart_vehicle_working => "Chart Vehicle Working";
  @override
  String get vehicle_model => "Model";
  @override
  String get period => "Period";
  @override
  String get dealer => "Dealer";
  @override
  String get current_location => "Current Location";
  @override
  String get driving_summary_time => "Driving Summary Time";
}

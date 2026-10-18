/// Web 端诊断日志：写入浏览器控制台（桌面端写本地文件）。
class DiagLog {
  DiagLog._();
  static final DiagLog instance = DiagLog._();

  void log(String msg) {
    // ignore: avoid_print
    print('[cfm] $msg');
  }
}

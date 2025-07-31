class GalacticTimeService {
  static getGT() {
    var diff = (DateTime.now().millisecondsSinceEpoch + 3471265902000) / 1000;
    return (diff / 1.0878277570776).toString();
  }
}

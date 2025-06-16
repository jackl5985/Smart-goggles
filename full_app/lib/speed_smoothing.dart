class SpeedProcessor {
  final List<_SpeedSample> _history = [];
  double _ema = 0.0;
  final double smoothingFactor = 0.2; // EMA alpha

  double get currentSpeed => _ema;
  
  void addSample(double speed, DateTime timestamp) {
    // Add raw sample
    _history.add(_SpeedSample(speed, timestamp));
    if (_history.length > 10) _history.removeAt(0);

    // Update EMA
    if (_ema == 0.0) {
      _ema = speed;
    } else {
      _ema = smoothingFactor * speed + (1 - smoothingFactor) * _ema;
    }
  }

  double interpolateSpeed(DateTime now) {
    if (_history.length < 2) return _ema;

    final recent = _history[_history.length - 1];
    final prev = _history[_history.length - 2];

    final dt = recent.timestamp.difference(prev.timestamp).inMilliseconds;
    final elapsed = now.difference(prev.timestamp).inMilliseconds;
    if (dt == 0) return recent.speed;

    final fraction = (elapsed / dt).clamp(0.0, 1.0);
    return prev.speed + (recent.speed - prev.speed) * fraction;
  }
}

class _SpeedSample {
  final double speed;
  final DateTime timestamp;
  _SpeedSample(this.speed, this.timestamp);
}
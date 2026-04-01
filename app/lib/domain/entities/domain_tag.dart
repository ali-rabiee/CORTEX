/// The seven knowledge domains tracked by CORTEX.
enum DomainTag {
  rl('Reinforcement Learning', 'RL'),
  robotLearning('Robot Learning', 'Robot'),
  perception('Perception', 'Percep.'),
  foundationModels('Foundation Models', 'FM'),
  generativeControl('Generative Control', 'GenCtrl'),
  systems('Systems', 'Systems'),
  mlFundamentals('ML Fundamentals', 'ML');

  const DomainTag(this.label, this.shortLabel);

  final String label;
  final String shortLabel;

  static DomainTag fromString(String value) {
    switch (value) {
      case 'rl':
        return DomainTag.rl;
      case 'robot_learning':
        return DomainTag.robotLearning;
      case 'perception':
        return DomainTag.perception;
      case 'foundation_models':
        return DomainTag.foundationModels;
      case 'generative_control':
        return DomainTag.generativeControl;
      case 'systems':
        return DomainTag.systems;
      case 'ml_fundamentals':
        return DomainTag.mlFundamentals;
      default:
        throw ArgumentError('Unknown domain tag: $value');
    }
  }

  String toJsonString() {
    switch (this) {
      case DomainTag.rl:
        return 'rl';
      case DomainTag.robotLearning:
        return 'robot_learning';
      case DomainTag.perception:
        return 'perception';
      case DomainTag.foundationModels:
        return 'foundation_models';
      case DomainTag.generativeControl:
        return 'generative_control';
      case DomainTag.systems:
        return 'systems';
      case DomainTag.mlFundamentals:
        return 'ml_fundamentals';
    }
  }
}

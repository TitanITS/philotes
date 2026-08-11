import '../../models/plans/philotes_plan.dart';

abstract class PlanService {
  const PlanService();

  List<PhilotesPlan> plans();

  PhilotesPlan? planById(
    String planId,
  );
}

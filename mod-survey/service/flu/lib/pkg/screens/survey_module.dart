import 'package:flutter_modular/flutter_modular.dart';
import 'package:mod_survey/pkg/screens/survey_view.dart';

class SurveyModule extends ChildModule {
  static String baseRoute;

  SurveyModule(String baseRoute) {
    if (baseRoute == '/') {
      baseRoute = '';
    }
    assert(baseRoute != null);
    SurveyModule.baseRoute = baseRoute;
  }

  @override
  List<Bind> get binds => [Bind((i) => baseRoute)];

  @override
  List<ModularRouter> get routers =>
      [ModularRouter('/', child: (_, args) => SurveyView())];

  static Inject get to => Inject<SurveyModule>.of();
}

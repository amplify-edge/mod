import 'package:flutter/widgets.dart';
import 'package:mod_survey/pkg/i18n/mod_survey_localizations.dart';
import 'package:research_package/model.dart';

///
/// CHOICES
///

List<RPImageChoice> images = [
  RPImageChoice.withParams(Image.asset('assets/images/very-sad.png'), 0,
      surveyTranslate('feelVerySad')),
  RPImageChoice.withParams(
      Image.asset('assets/images/sad.png'), 0, surveyTranslate('feelSad')),
  RPImageChoice.withParams(
      Image.asset('assets/images/ok.png'), 0, surveyTranslate('feelOk')),
  RPImageChoice.withParams(
      Image.asset('assets/images/happy.png'), 0, surveyTranslate('feelHappy')),
  RPImageChoice.withParams(Image.asset('assets/images/very-happy.png'), 0,
      surveyTranslate('feelVeryHappy')),
];

List<RPChoice> joyfulActivities = [
  RPChoice.withParams(surveyTranslate('playingGames'), 6),
  RPChoice.withParams(surveyTranslate('jogging'), 5),
  RPChoice.withParams(surveyTranslate('playingInstrument'), 4),
  RPChoice.withParams(surveyTranslate('familyAndFriends'), 3),
  RPChoice.withParams(surveyTranslate('doingSports'), 2),
  RPChoice.withParams(surveyTranslate('reading'), 1),
  RPChoice.withParams(surveyTranslate('beingProductive'), 0),
];

List<RPChoice> who5Choices = [
  RPChoice.withParams(surveyTranslate('allOfTheTime'), 5),
  RPChoice.withParams(surveyTranslate('mostOfTheTime'), 4),
  RPChoice.withParams(surveyTranslate('moreThanHalfOfTheTime'), 3),
  RPChoice.withParams(surveyTranslate("lessThanHalfOfTheTime"), 2),
  RPChoice.withParams(surveyTranslate("someOfTheTime"), 1),
  RPChoice.withParams(surveyTranslate("atNoTime"), 0),
];

List<RPChoice> instruments = [
  RPChoice.withParams(surveyTranslate("piano"), 1),
  RPChoice.withParams(surveyTranslate("guitar"), 0),
];

List<RPChoice> guitarReasons = [
  RPChoice.withParams(surveyTranslate("fun"), 3),
  RPChoice.withParams(surveyTranslate("easyToPlay"), 2),
  RPChoice.withParams(surveyTranslate("charming"), 1),
  RPChoice.withParams(surveyTranslate("popular"), 0),
];

List<RPChoice> numbers = [
  RPChoice.withParams(surveyTranslate("four"), 3),
  RPChoice.withParams(surveyTranslate("three"), 2),
  RPChoice.withParams(surveyTranslate("two"), 1),
  RPChoice.withParams(surveyTranslate("one"), 0),
];

List<RPChoice> alphabet = [
  RPChoice.withParams("D", 3),
  RPChoice.withParams("C", 2),
  RPChoice.withParams("B", 1),
  RPChoice.withParams("A", 0),
];

///
/// ANSWER FORMATS
///

RPBooleanAnswerFormat yesNoAnswerFormat = RPBooleanAnswerFormat.withParams(
  surveyTranslate("yes"),
  surveyTranslate("no"),
);
RPImageChoiceAnswerFormat imageChoiceAnswerFormat =
    RPImageChoiceAnswerFormat.withParams(images);
RPIntegerAnswerFormat nrOfCigarettesAnswerFormat =
    RPIntegerAnswerFormat.withParams(0, 200, surveyTranslate("cigarettes"));
RPChoiceAnswerFormat who5AnswerFormat = RPChoiceAnswerFormat.withParams(
    ChoiceAnswerStyle.SingleChoice, who5Choices);
RPChoiceAnswerFormat joyfulActivitiesAnswerFormat =
    RPChoiceAnswerFormat.withParams(
        ChoiceAnswerStyle.MultipleChoice, joyfulActivities);
RPChoiceAnswerFormat numbersAnswerFormat =
    RPChoiceAnswerFormat.withParams(ChoiceAnswerStyle.MultipleChoice, numbers);
RPChoiceAnswerFormat alphabetAnswerFormat =
    RPChoiceAnswerFormat.withParams(ChoiceAnswerStyle.MultipleChoice, alphabet);
RPChoiceAnswerFormat instrumentsAnswerFormat = RPChoiceAnswerFormat.withParams(
    ChoiceAnswerStyle.SingleChoice, instruments);
RPIntegerAnswerFormat minutesIntegerAnswerFormat =
    RPIntegerAnswerFormat.withParams(0, 10000, surveyTranslate("minutes"));
RPChoiceAnswerFormat guitarAnswerFormat = RPChoiceAnswerFormat.withParams(
    ChoiceAnswerStyle.MultipleChoice, guitarReasons);

///
/// STEPS
///

RPQuestionStep smokingQuestionStep = RPQuestionStep.withAnswerFormat(
    "smokingQuestionId", surveyTranslate("smokingQuestion"), yesNoAnswerFormat);

RPQuestionStep imageChoiceQuestionStep = RPQuestionStep.withAnswerFormat(
  "imageStepID",
  surveyTranslate('imageChoiceQuestion'),
  imageChoiceAnswerFormat,
);

RPQuestionStep nrOfCigarettesQuestionStep = RPQuestionStep.withAnswerFormat(
    "nrOfCigarettesQuestionStepID",
    surveyTranslate('numberOfCigarettesQuestion'),
    nrOfCigarettesAnswerFormat);

RPInstructionStep instructionStep = RPInstructionStep(
  identifier: "instructionID",
  title: surveyTranslate('instructionWelcome'),
  detailText: surveyTranslate('instructionDetails'),
)..text = surveyTranslate('instructionText');

RPQuestionStep singleChoiceQuestionStep = RPQuestionStep.withAnswerFormat(
  "singleChoiceQuestionStepID",
  surveyTranslate('singleChoiceQuestion'),
  who5AnswerFormat,
);

RPQuestionStep multiChoiceQuestionStep1 = RPQuestionStep.withAnswerFormat(
  "multiChoiceQuestionStepID1",
  surveyTranslate('multiChoiceQuestionStep1'),
  joyfulActivitiesAnswerFormat,
);

RPQuestionStep multiChoiceQuestionStep2 = RPQuestionStep.withAnswerFormat(
  "multiChoiceQuestionStepID2",
  surveyTranslate('multiChoiceQuestionStep2'),
  numbersAnswerFormat,
);

RPQuestionStep alphabetQuestionStep = RPQuestionStep.withAnswerFormat(
  "alphabetQuestionStepID",
  surveyTranslate('alphabetQuestion'),
  alphabetAnswerFormat,
);

RPInstructionStep instructionStepA = RPInstructionStep(
    identifier: "instructionStepAID",
    title: "A",
    detailText: "A " + surveyTranslate('alphabetDetail'))
  ..text = "text";
RPInstructionStep instructionStepB = RPInstructionStep(
    identifier: "instructionStepBID",
    title: "B",
    detailText: "B " + surveyTranslate('alphabetDetail'))
  ..text = "text";
RPInstructionStep instructionStepC = RPInstructionStep(
    identifier: "instructionStepCID",
    title: "C",
    detailText: "C " + surveyTranslate('alphabetDetail'))
  ..text = "text";
RPInstructionStep instructionStepD = RPInstructionStep(
    identifier: "instructionStepDID",
    title: "D",
    detailText: "D " + surveyTranslate('alphabetDetail'))
  ..text = "text";

RPQuestionStep instrumentChoiceQuestionStep = RPQuestionStep.withAnswerFormat(
    "instrumentChoiceQuestionStepID",
    surveyTranslate('instrumentQuestion'),
    instrumentsAnswerFormat);
RPQuestionStep minutesQuestionStep = RPQuestionStep.withAnswerFormat(
    "minutesQuestionStepID",
    surveyTranslate('instrumentMinutesQuestion'),
    minutesIntegerAnswerFormat);
RPFormStep formStep = RPFormStep.withTitle(
  "formstepID",
  [instrumentChoiceQuestionStep, minutesQuestionStep],
  surveyTranslate('musicQuestion'),
  optional: true,
);

RPQuestionStep guitarChoiceQuestionStep = RPQuestionStep.withAnswerFormat(
    "guitarChoiceQuestionStepID",
    surveyTranslate('guitarChoiceQuestion'),
    guitarAnswerFormat);

RPCompletionStep completionStep = RPCompletionStep("completionID")
  ..title = surveyTranslate('completionFinished')
  ..text = surveyTranslate('completionText');

///
/// PREDICATES
///

RPResultPredicate singleChoicePredicate =
    RPResultPredicate.forChoiceQuestionResult(
        resultSelector:
            RPResultSelector.forStepId("singleChoiceQuestionStepID"),
        expectedValue: [5],
        choiceQuestionResultPredicateMode:
            ChoiceQuestionResultPredicateMode.ExactMatch);

RPResultPredicate exactMultiChoicePredicate =
    RPResultPredicate.forChoiceQuestionResult(
        resultSelector:
            RPResultSelector.forStepId("multiChoiceQuestionStepID1"),
        expectedValue: [0, 6],
        choiceQuestionResultPredicateMode:
            ChoiceQuestionResultPredicateMode.ExactMatch);

RPResultPredicate containingMultiChoicePredicate =
    RPResultPredicate.forChoiceQuestionResult(
        resultSelector:
            RPResultSelector.forStepId("multiChoiceQuestionStepID2"),
        expectedValue: [1],
        choiceQuestionResultPredicateMode:
            ChoiceQuestionResultPredicateMode.Containing);

RPResultPredicate yesSmokingPredicate =
    RPResultPredicate.forBooleanQuestionResult(
        resultSelector: RPResultSelector.forStepId("smokingQuestionId"),
        expectedValue: true);

RPResultPredicate noSmokingPredicate =
    RPResultPredicate.forBooleanQuestionResult(
        resultSelector: RPResultSelector.forStepId("smokingQuestionId"),
        expectedValue: false);

RPResultPredicate instrumentChoicePredicate =
    RPResultPredicate.forChoiceQuestionResult(
        resultSelector: RPResultSelector.forStepIdInFormStep(
            "instrumentChoiceQuestionStepID"),
        expectedValue: [1],
        choiceQuestionResultPredicateMode:
            ChoiceQuestionResultPredicateMode.ExactMatch);

///
/// NAVIGATION RULES
///

RPPredicateStepNavigationRule smokingNavigationRule =
    RPPredicateStepNavigationRule(
  {
    noSmokingPredicate: imageChoiceQuestionStep.identifier,
  },
);

RPPredicateStepNavigationRule singleChoiceNavigationRule =
    RPPredicateStepNavigationRule(
  {
    singleChoicePredicate: imageChoiceQuestionStep.identifier,
  },
);

RPPredicateStepNavigationRule exactMultiChoiceNavigationRule =
    RPPredicateStepNavigationRule(
  {
    exactMultiChoicePredicate: imageChoiceQuestionStep.identifier,
  },
);

RPPredicateStepNavigationRule containingMultiChoiceNavigationRule =
    RPPredicateStepNavigationRule(
  {
    containingMultiChoicePredicate: imageChoiceQuestionStep.identifier,
  },
);

RPPredicateStepNavigationRule guitarNavigationRule =
    RPPredicateStepNavigationRule(
  {
    instrumentChoicePredicate: smokingQuestionStep.identifier,
  },
);

RPStepReorganizerRule alphabetReorganizerRule =
    RPStepReorganizerRule(alphabetQuestionStep.identifier, {
  3: instructionStepD.identifier,
  2: instructionStepC.identifier,
  1: instructionStepB.identifier,
  0: instructionStepA.identifier
});

///
/// TASK
///

RPNavigableOrderedTask navigableSurveyTask = RPNavigableOrderedTask(
  "NavigableTaskID",
  [
    instructionStep,
    formStep,
    guitarChoiceQuestionStep,
    smokingQuestionStep,
    alphabetQuestionStep,
    instructionStepA,
    instructionStepB,
    instructionStepC,
    instructionStepD,
    nrOfCigarettesQuestionStep,
    multiChoiceQuestionStep1,
    multiChoiceQuestionStep2,
    singleChoiceQuestionStep,
    imageChoiceQuestionStep,
    completionStep,
  ],
)
  ..setNavigationRuleForTriggerStepIdentifier(
      smokingNavigationRule, smokingQuestionStep.identifier)
  ..setNavigationRuleForTriggerStepIdentifier(
      singleChoiceNavigationRule, singleChoiceQuestionStep.identifier)
  ..setNavigationRuleForTriggerStepIdentifier(
      exactMultiChoiceNavigationRule, multiChoiceQuestionStep1.identifier)
  ..setNavigationRuleForTriggerStepIdentifier(
      guitarNavigationRule, formStep.identifier)
  ..setNavigationRuleForTriggerStepIdentifier(
      containingMultiChoiceNavigationRule, multiChoiceQuestionStep2.identifier)
  ..setNavigationRuleForTriggerStepIdentifier(
      alphabetReorganizerRule, alphabetQuestionStep.identifier);

//RPDirectStepNavigationRule navigationRuleAfterSmokingResult =
//    RPDirectStepNavigationRule(imageChoiceQuestionStep.identifier);

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Translations {
  Locale locale;

  String feelHappy() {
    return Intl.message(
      'Feeling happy',
      name: 'feelHappy',
      desc: 'feelHappy',
      locale: locale.toString(),
    );
  }

  String feelVerySad() {
    return Intl.message(
      'Feeling very sad',
      name: 'feelVerySad',
      desc: 'feelVerySad',
      locale: locale.toString(),
    );
  }

  String feelSad() {
    return Intl.message(
      'Feeling sad',
      name: 'feelSad',
      desc: 'feelSad',
      locale: locale.toString(),
    );
  }

  String feelOk() {
    return Intl.message(
      'Feeling Ok',
      name: 'feelOk',
      desc: 'feelOk',
      locale: locale.toString(),
    );
  }

  String feelVeryHappy() {
    return Intl.message(
      'Feeling very happy',
      name: 'feelVeryHappy',
      desc: 'feelVeryHappy',
      locale: locale.toString(),
    );
  }

  String playingGames() {
    return Intl.message(
      'Playing games',
      name: 'playingGames',
      desc: 'playingGames',
      locale: locale.toString(),
    );
  }

  String jogging() {
    return Intl.message(
      'Jogging',
      name: 'jogging',
      desc: 'jogging',
      locale: locale.toString(),
    );
  }

  String playingInstrument() {
    return Intl.message(
      'Playing an instrument',
      name: 'playingInstrument',
      desc: 'playingInstrument',
      locale: locale.toString(),
    );
  }

  String familyAndFriends() {
    return Intl.message(
      'Family and Friends',
      name: 'familyAndFriends',
      desc: 'familyAndFriends',
      locale: locale.toString(),
    );
  }

  String doingSports() {
    return Intl.message(
      'Doing Sports',
      name: 'doingSports',
      desc: 'doingSports',
      locale: locale.toString(),
    );
  }

  String reading() {
    return Intl.message(
      'Reading',
      name: 'reading',
      desc: 'reading',
      locale: locale.toString(),
    );
  }

  String beingProductive() {
    return Intl.message(
      'Being productive',
      name: 'beingProductive',
      desc: 'beingProductive',
      locale: locale.toString(),
    );
  }

  String allOfTheTime() {
    return Intl.message(
      'All of the time',
      name: 'allOfTheTime',
      desc: 'allOfTheTime',
      locale: locale.toString(),
    );
  }

  String mostOfTheTime() {
    return Intl.message(
      'Most of the time',
      name: 'mostOfTheTime',
      desc: 'mostOfTheTime',
      locale: locale.toString(),
    );
  }

  String moreThanHalfOfTheTime() {
    return Intl.message(
      'More than half of the time',
      name: 'moreThanHalfOfTheTime',
      desc: 'moreThanHalfOfTheTime',
      locale: locale.toString(),
    );
  }

  String lessThanHalfOfTheTime() {
    return Intl.message(
      'Less than half of the time',
      name: 'lessThanHalfOfTheTime',
      desc: 'lessThanHalfOfTheTime',
      locale: locale.toString(),
    );
  }

  String someOfTheTime() {
    return Intl.message(
      'Some of the time',
      name: 'someOfTheTime',
      desc: 'someOfTheTime',
      locale: locale.toString(),
    );
  }

  String atNoTime() {
    return Intl.message(
      'At no time',
      name: 'atNoTime',
      desc: 'atNoTime',
      locale: locale.toString(),
    );
  }

  String piano() {
    return Intl.message(
      'Piano',
      name: 'piano',
      desc: 'piano',
      locale: locale.toString(),
    );
  }

  String guitar() {
    return Intl.message(
      'Guitar',
      name: 'guitar',
      desc: 'guitar',
      locale: locale.toString(),
    );
  }

  String fun() {
    return Intl.message(
      'Fun',
      name: 'fun',
      desc: 'fun',
      locale: locale.toString(),
    );
  }

  String easyToPlay() {
    return Intl.message(
      'Easy to play',
      name: 'easyToPlay',
      desc: 'easyToPlay',
      locale: locale.toString(),
    );
  }

  String charming() {
    return Intl.message(
      'Charming',
      name: 'charming',
      desc: 'charming',
      locale: locale.toString(),
    );
  }

  String popular() {
    return Intl.message(
      'Popular',
      name: 'popular',
      desc: 'popular',
      locale: locale.toString(),
    );
  }

  String one() {
    return Intl.message(
      'One',
      name: 'one',
      desc: 'one',
      locale: locale.toString(),
    );
  }

  String two() {
    return Intl.message(
      'Two',
      name: 'two',
      desc: 'two',
      locale: locale.toString(),
    );
  }

  String three() {
    return Intl.message(
      'Three',
      name: 'three',
      desc: 'three',
      locale: locale.toString(),
    );
  }

  String four() {
    return Intl.message(
      'Four',
      name: 'four',
      desc: 'four',
      locale: locale.toString(),
    );
  }

  String smokingQuestion() {
    return Intl.message(
      'Do you smoke?',
      name: 'smokingQuestion',
      desc: 'smokingQuestion',
      locale: locale.toString(),
    );
  }

  String imageChoiceQuestion() {
    return Intl.message(
      'Indicate your mood by selecting a picture!',
      name: 'imageChoiceQuestion',
      desc: 'imageChoiceQuestion',
      locale: locale.toString(),
    );
  }

  String numberOfCigsQuestion() {
    return Intl.message(
      'How many cigarettes do you smoke a day',
      name: 'numberOfCigsQuestion',
      desc: 'numberOfCigsQuestion',
      locale: locale.toString(),
    );
  }

  String instructionWelcome() {
    return Intl.message(
      'Welcome!',
      name: 'instructionWelcome',
      desc: 'instructionWelcome',
      locale: locale.toString(),
    );
  }

  String instructionDetails() {
    return Intl.message(
      'For the sake of science of course...',
      name: 'instructionDetails',
      desc: 'instructionDetails',
      locale: locale.toString(),
    );
  }

  String instructionText() {
    return Intl.message(
      "Please fill out this questionnaire!\n\nIn this questionnaire answers to some questions will determine what other questions you will get. You can not skip these question, although you are free to skip the other questions.",
      name: 'instructionText',
      desc: 'instructionText',
      locale: locale.toString(),
    );
  }

  String singleChoiceQuestion() {
    return Intl.message(
      "I have felt cheerful and in good spirits",
      name: 'singleChoiceQuestion',
      desc: 'singleChoiceQuestion',
      locale: locale.toString(),
    );
  }

  String multiChoiceQuestionStep1() {
    return Intl.message(
      "What makes you happy?",
      name: 'multiChoiceQuestionStep1',
      desc: 'multiChoiceQuestionStep1',
      locale: locale.toString(),
    );
  }

  String multiChoiceQuestionStep2() {
    return Intl.message(
      "Choose (a) number(s)",
      name: 'multiChoiceQuestionStep2',
      desc: 'multiChoiceQuestionStep2',
      locale: locale.toString(),
    );
  }

  String alphabetQuestion() {
    return Intl.message(
      "Choose (a) letter(s)",
      name: 'alphabetQuestion',
      desc: 'alphabetQuestion',
      locale: locale.toString(),
    );
  }

  String alphabetDetail() {
    return Intl.message(
      "detail",
      name: 'alphabetDetail',
      desc: 'alphabetDetail',
      locale: locale.toString(),
    );
  }

  String instrumentQuestion() {
    return Intl.message(
      "Which instrument are you playing?",
      name: 'instrumentQuestion',
      desc: 'instrumentQuestion',
      locale: locale.toString(),
    );
  }

  String instrumentMinutesQuestion() {
    return Intl.message(
      "How many minutes do you spend practicing a week?",
      name: 'instrumentMinutesQuestion',
      desc: 'instrumentMinutesQuestion',
      locale: locale.toString(),
    );
  }

  String musicQuestion() {
    return Intl.message(
      "Questions about music",
      name: 'musicQuestion',
      desc: 'musicQuestion',
      locale: locale.toString(),
    );
  }

  String guitarChoiceQuestion() {
    return Intl.message(
      "Why did you start playing the guitar?",
      name: 'guitarChoiceQuestion',
      desc: 'guitarChoiceQuestion',
      locale: locale.toString(),
    );
  }

  String completionFinished() {
    return Intl.message(
      "Finished",
      name: 'completionFinished',
      desc: 'completionFinished',
      locale: locale.toString(),
    );
  }

  String completionText() {
    return Intl.message(
      "Thank you for filling out the survey",
      name: 'completionText',
      desc: 'completionText',
      locale: locale.toString(),
    );
  }
}

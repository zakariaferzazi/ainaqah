// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on AppStoreBase, Store {
  final _$isLoadingAtom = Atom(name: 'AppStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$isLoggedInAtom = Atom(name: 'AppStoreBase.isLoggedIn');

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  final _$isNetworkAvailableAtom =
      Atom(name: 'AppStoreBase.isNetworkAvailable');

  @override
  bool get isNetworkAvailable {
    _$isNetworkAvailableAtom.reportRead();
    return super.isNetworkAvailable;
  }

  @override
  set isNetworkAvailable(bool value) {
    _$isNetworkAvailableAtom.reportWrite(value, super.isNetworkAvailable, () {
      super.isNetworkAvailable = value;
    });
  }

  final _$isGuestUserLoggedInAtom =
      Atom(name: 'AppStoreBase.isGuestUserLoggedIn');

  @override
  bool get isGuestUserLoggedIn {
    _$isGuestUserLoggedInAtom.reportRead();
    return super.isGuestUserLoggedIn;
  }

  @override
  set isGuestUserLoggedIn(bool value) {
    _$isGuestUserLoggedInAtom.reportWrite(value, super.isGuestUserLoggedIn, () {
      super.isGuestUserLoggedIn = value;
    });
  }

  final _$isDarkModeOnAtom = Atom(name: 'AppStoreBase.isDarkModeOn');

  @override
  bool get isDarkModeOn {
    _$isDarkModeOnAtom.reportRead();
    return super.isDarkModeOn;
  }

  @override
  set isDarkModeOn(bool value) {
    _$isDarkModeOnAtom.reportWrite(value, super.isDarkModeOn, () {
      super.isDarkModeOn = value;
    });
  }

  final _$countAtom = Atom(name: 'AppStoreBase.count');

  @override
  int? get count {
    _$countAtom.reportRead();
    return super.count;
  }

  @override
  set count(int? value) {
    _$countAtom.reportWrite(value, super.count, () {
      super.count = value;
    });
  }

  final _$mIsUserExistInReviewAtom =
      Atom(name: 'AppStoreBase.mIsUserExistInReview');

  @override
  bool get mIsUserExistInReview {
    _$mIsUserExistInReviewAtom.reportRead();
    return super.mIsUserExistInReview;
  }

  @override
  set mIsUserExistInReview(bool value) {
    _$mIsUserExistInReviewAtom.reportWrite(value, super.mIsUserExistInReview,
        () {
      super.mIsUserExistInReview = value;
    });
  }

  final _$isNotificationOnAtom = Atom(name: 'AppStoreBase.isNotificationOn');

  @override
  bool get isNotificationOn {
    _$isNotificationOnAtom.reportRead();
    return super.isNotificationOn;
  }

  @override
  set isNotificationOn(bool value) {
    _$isNotificationOnAtom.reportWrite(value, super.isNotificationOn, () {
      super.isNotificationOn = value;
    });
  }

  final _$isDarkModeAtom = Atom(name: 'AppStoreBase.isDarkMode');

  @override
  bool? get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool? value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  final _$selectedLanguageCodeAtom =
      Atom(name: 'AppStoreBase.selectedLanguageCode');

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  final _$indexAtom = Atom(name: 'AppStoreBase.index');

  @override
  int get index {
    _$indexAtom.reportRead();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.reportWrite(value, super.index, () {
      super.index = value;
    });
  }

  final _$dashboardScreeListAtom =
      Atom(name: 'AppStoreBase.dashboardScreeList');

  @override
  List<Widget> get dashboardScreeList {
    _$dashboardScreeListAtom.reportRead();
    return super.dashboardScreeList;
  }

  @override
  set dashboardScreeList(List<Widget> value) {
    _$dashboardScreeListAtom.reportWrite(value, super.dashboardScreeList, () {
      super.dashboardScreeList = value;
    });
  }

  final _$toggleDarkModeAsyncAction =
      AsyncAction('AppStoreBase.toggleDarkMode');

  @override
  Future<void> toggleDarkMode({bool? value}) {
    return _$toggleDarkModeAsyncAction
        .run(() => super.toggleDarkMode(value: value));
  }

  final _$setDarkModeAsyncAction = AsyncAction('AppStoreBase.setDarkMode');

  @override
  Future<void> setDarkMode({bool? aIsDarkMode}) {
    return _$setDarkModeAsyncAction
        .run(() => super.setDarkMode(aIsDarkMode: aIsDarkMode));
  }

  final _$setLanguageAsyncAction = AsyncAction('AppStoreBase.setLanguage');

  @override
  Future<void> setLanguage(String aSelectedLanguageCode) {
    return _$setLanguageAsyncAction
        .run(() => super.setLanguage(aSelectedLanguageCode));
  }

  final _$AppStoreBaseActionController = ActionController(name: 'AppStoreBase');

  @override
  void setLoading(bool aIsLoading) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setLoading');
    try {
      return super.setLoading(aIsLoading);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConnectionState(ConnectivityResult val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setConnectionState');
    try {
      return super.setConnectionState(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBottomNavigationIndex(int val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setBottomNavigationIndex');
    try {
      return super.setBottomNavigationIndex(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoggedIn(bool val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setLoggedIn');
    try {
      return super.setLoggedIn(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setGuestUserLoggedIn(bool val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setGuestUserLoggedIn');
    try {
      return super.setGuestUserLoggedIn(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment() {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.increment');
    try {
      return super.increment();
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrement({int? qty}) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.decrement');
    try {
      return super.decrement(qty: qty);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCount(int? aCount) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setCount');
    try {
      return super.setCount(aCount);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNotification(bool val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setNotification');
    try {
      return super.setNotification(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isLoggedIn: ${isLoggedIn},
isNetworkAvailable: ${isNetworkAvailable},
isGuestUserLoggedIn: ${isGuestUserLoggedIn},
isDarkModeOn: ${isDarkModeOn},
count: ${count},
mIsUserExistInReview: ${mIsUserExistInReview},
isNotificationOn: ${isNotificationOn},
isDarkMode: ${isDarkMode},
selectedLanguageCode: ${selectedLanguageCode},
index: ${index},
dashboardScreeList: ${dashboardScreeList}
    ''';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../AppLocalizations.dart';
import '/../main.dart';
import '/../models/LayoutTypeSelectModel.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class LayoutSelectionCategory extends StatefulWidget {
  final int? crossAxisCount;
  final Function? callBack;

  LayoutSelectionCategory({this.crossAxisCount, this.callBack});

  @override
  _LayoutSelectionCategoryState createState() => _LayoutSelectionCategoryState();
}

class _LayoutSelectionCategoryState extends State<LayoutSelectionCategory> {
  List<LayoutTypesSelection> select = [];
  int? mCrossValue;

  @override
  void initState() {
    super.initState();
    init();
    mCrossValue = widget.crossAxisCount;
  }

  init() async {
    select.clear();
    select.add(LayoutTypesSelection(image: Icon(Icons.list_rounded), isSelected: false));
    select.add(LayoutTypesSelection(image: Icon(Ionicons.ios_grid_outline), isSelected: false));
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return Container(
      color: primaryColor,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appLocalization.translate('lbl_layout')!, style: boldTextStyle(size: 18, color: Colors.white)),
          10.height,
          Container(
            height: 45,
            child: AnimatedListView(
              itemCount: select.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: select[index].isSelected! ? Colors.black54.withOpacity(0.2) : Colors.white.withOpacity(0.2)),
                    child: IconButton(
                      icon:select[index].image!, color: select[index].isSelected! ? Colors.black : Colors.white,
                      onPressed: () async {
                        init();
                        select[index].isSelected = !select[index].isSelected!;
                        setState(() {});
                        if (index == 0)
                          mCrossValue = 1;
                        else if (index == 1)
                          mCrossValue = 2;
                        else if (index == 2)
                          mCrossValue = 3;
                        else if (index == 3)
                          mCrossValue = 4;
                        else
                          mCrossValue = 2;
                        setValue(CATEGORY_CROSS_AXIS_COUNT, mCrossValue);
                        widget.callBack!(mCrossValue);
                        finish(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

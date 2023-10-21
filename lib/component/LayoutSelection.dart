import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../AppLocalizations.dart';
import '/../main.dart';
import '/../models/LayoutTypeSelectModel.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class LayoutSelection extends StatefulWidget {
  final int? crossAxisCount;
  final Function? callBack;

  LayoutSelection({this.crossAxisCount, this.callBack});

  @override
  _LayoutSelectionState createState() => _LayoutSelectionState();
}

class _LayoutSelectionState extends State<LayoutSelection> {
  List<LayoutTypesSelection> select = [];
  int? crossvalue;

  @override
  void initState() {
    super.initState();
    init();
    crossvalue = widget.crossAxisCount;
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
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: select[index].isSelected! ? Colors.white.withOpacity(0.2) : Colors.black54.withOpacity(0.2)),
                    child: IconButton(
                      icon: select[index].image!,
                      color: select[index].isSelected! ? Colors.black : Colors.white,
                      onPressed: () async {
                        init();
                        select[index].isSelected = !select[index].isSelected!;
                        setState(() {});
                        if (index == 0)
                          crossvalue = 1;
                        else if (index == 1)
                          crossvalue = 2;
                        else if (index == 2)
                          crossvalue = 3;
                        else
                          crossvalue = 2;
                        setValue(CROSS_AXIS_COUNT, crossvalue);
                        widget.callBack!(crossvalue);
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

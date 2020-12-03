import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:mod_disco/rpc/v2/mod_disco_models.pb.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DataPane extends StatelessWidget {
  final SizingInformation sizingInfo;
  final bool isLoading;
  final int rowsPerPage;
  final int totalCount;
  final void Function() handleNext;
  final void Function() handlePrevious;
  final int rowsOffset;
  final List<SurveyValuePlusAccount> items;
  final void Function() onRefresh;
  final void Function(int) onRowsPerPageChanged;

  const DataPane({
    Key key,
    @required this.totalCount,
    @required this.isLoading,
    @required this.rowsPerPage,
    @required this.handleNext,
    @required this.handlePrevious,
    @required this.rowsOffset,
    @required this.items,
    @required this.sizingInfo,
    @required this.onRefresh,
    @required this.onRowsPerPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : rowsPerPage == 0
            ? Container()
            : NativeDataTable.builder(
                sortAscending: false,
                rowsPerPage: rowsPerPage,
                itemCount: totalCount,
                firstRowIndex: rowsOffset ?? 0,
                handleNext: handleNext,
                handlePrevious: handlePrevious,
                itemBuilder: (int index) {
                  final SurveyValuePlusAccount item = items[index];
                  return DataRow.byIndex(index: index,
                      // selected: item.selected,
                      // onSelectChanged: (bool value) {},
                      cells: <DataCell>[
                        DataCell(Text('${item.sysAccountUserRefName}')),
                        DataCell(Text('${item.pledged.toInt()}')),
                        DataCell(
                            Text('${item.createdAt.toDateTime().toString()}')),
                      ]);
                },
                header: const Text('Survey Value'),
                // sortColumnIndex: _sortColumnIndex,
                // sortAscending: _sortAscending,
                onRefresh: onRefresh,
                onRowsPerPageChanged: onRowsPerPageChanged,
                // mobileItemBuilder: (BuildContext context, int index) {
                //   final i = _desserts[index];
                //   return ListTile(
                //     title: Text(i?.name),
                //   );
                // },
                rowCountApproximate: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {},
                  ),
                ],
                columns: <DataColumn>[
                  DataColumn(
                    label: const Text('Account'),
                    tooltip: 'Account name.',
                  ),
                  DataColumn(
                    label: const Text('Pledged'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: const Text('Date Posted'),
                    tooltip: 'Date created',
                  ),
                ],
              );
  }
}

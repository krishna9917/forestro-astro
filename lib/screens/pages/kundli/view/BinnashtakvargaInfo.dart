import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/kundali/Binnashtakvarga_Model.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';

class BinnashtakvargaInfo extends StatelessWidget {
  final Binnashtakvarga_Model binnashtakvarga_model;
  const BinnashtakvargaInfo({super.key, required this.binnashtakvarga_model});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.windowWidth,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowColor: WidgetStatePropertyAll(Colors.white),
          showBottomBorder: true,
          border: TableBorder.all(color: Colors.grey, width: 0.5),
          columns: const [
            DataColumn(label: Text('Ascendant')),
            DataColumn(label: Text('Sun')),
            DataColumn(label: Text('Moon')),
            DataColumn(label: Text('Mars')),
            DataColumn(label: Text('Mercury')),
            DataColumn(label: Text('Jupiter')),
            DataColumn(label: Text('Saturn')),
            DataColumn(label: Text('Venus')),
          ],
          rows: List.generate(
            binnashtakvarga_model.response!.ascendant!.length,
            (index) {
              return DataRow(
                  color: WidgetStatePropertyAll(Colors.white),
                  cells: <DataCell>[
                    DataCell(Text(binnashtakvarga_model
                        .response!.ascendant![index]
                        .toString())),
                    DataCell(Text(binnashtakvarga_model.response!.sun![index]
                        .toString())),
                    DataCell(Text(binnashtakvarga_model.response!.moon![index]
                        .toString())),
                    DataCell(Text(binnashtakvarga_model.response!.mars![index]
                        .toString())),
                    DataCell(Text(binnashtakvarga_model
                        .response!.mercury![index]
                        .toString())),
                    DataCell(Text(binnashtakvarga_model
                        .response!.jupiter![index]
                        .toString())),
                    DataCell(Text(binnashtakvarga_model.response!.saturn![index]
                        .toString())),
                    DataCell(Text(binnashtakvarga_model.response!.venus![index]
                        .toString())),
                  ]);
            },
          ),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/bond_view_model.dart';

/// ---------------------------------------------------------------------------
/// ADD BOND VIEW
/// ---------------------------------------------------------------------------
/// - Supports both Single and Multiple bond creation
/// - Loads bond series list from [BondViewModel]
/// - Calls either [BondViewModel.submitSingle] or [BondViewModel.submitBulk]
/// ---------------------------------------------------------------------------
class AddBondView extends StatefulWidget {
  const AddBondView({super.key});

  @override
  State<AddBondView> createState() => _AddBondViewState();
}

class _AddBondViewState extends State<AddBondView> {
  bool isMultiple = false;

  final _priceCtrl = TextEditingController();
  final _bondCodeCtrl = TextEditingController();
  final _startNumberCtrl = TextEditingController();
  final _totalBondCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BondViewModel>().loadSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BondViewModel>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          ///  Background
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF5FBF5), Color(0xFFE9F6EA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          ///  Page Body
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildToggleButtons(),
                const SizedBox(height: 20),
                _buildSeriesDropdown(vm),
                const SizedBox(height: 14),

                ///  Single Bond Fields
                if (!isMultiple) ...[
                  _buildField("Bond Price", "Enter price", _priceCtrl),
                  const SizedBox(height: 12),
                  _buildField("Bond Code", "Example: AA", _bondCodeCtrl),
                ]

                ///  Multiple Bond Fields
                else ...[
                  _buildField("Bond Price", "Enter price", _priceCtrl),
                  const SizedBox(height: 12),
                  _buildField(
                    "Start Prize Bond Number",
                    "Example: CD69875472412",
                    _startNumberCtrl,
                  ),
                  const SizedBox(height: 12),
                  _buildField("Total Bond", "Enter total count", _totalBondCtrl),
                ],

                const SizedBox(height: 22),

                ///  Submit Button
                ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                    final ok = await _submit(vm);
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(vm.message ?? 'Unknown error'),
                        backgroundColor:
                        ok ? AppTheme.primary : Colors.redAccent,
                      ),
                    );

                    if (ok) {
                      _priceCtrl.clear();
                      _bondCodeCtrl.clear();
                      _startNumberCtrl.clear();
                      _totalBondCtrl.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: vm.isLoading
                      ? const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2)
                      : const Text(
                    "Add Bond",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  HEADER
  // ---------------------------------------------------------------------------
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(.08),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary, width: 2),
            ),
            child: const Icon(Icons.card_giftcard,
                color: AppTheme.primary, size: 28),
          ),
          const SizedBox(width: 14),
          const Text(
            "Add Prize Bond",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SINGLE / MULTIPLE TOGGLE
  // ---------------------------------------------------------------------------
  Widget _buildToggleButtons() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _toggleButton("Single", !isMultiple, () {
            setState(() => isMultiple = false);
          }),
          _toggleButton("Multiple", isMultiple, () {
            setState(() => isMultiple = true);
          }),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SERIES DROPDOWN
  // ---------------------------------------------------------------------------
  Widget _buildSeriesDropdown(BondViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prize Bond Series',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF6EA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.green.withOpacity(0.4)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: vm.selectedSeriesId,
              hint: Text(
                vm.isLoading
                    ? 'Loading...'
                    : (vm.series.isEmpty ? 'No data found' : 'Select Series'),
              ),
              isExpanded: true,
              items: vm.series.map((item) {
                return DropdownMenuItem<String>(
                  value: item['id'].toString(),
                  child: Text(item['name'].toString()),
                );
              }).toList(),
              onChanged: vm.isLoading
                  ? null
                  : (value) {
                final item = vm.series
                    .firstWhere((e) => e['id'].toString() == value);
                vm.setSelectedSeries(
                  item['id'].toString(),
                  item['code'].toString(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //  INPUT FIELD
  // ---------------------------------------------------------------------------
  Widget _buildField(String label, String hint, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFEAF6EA),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.green.withOpacity(0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              const BorderSide(color: AppTheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //  SUBMIT
  // ---------------------------------------------------------------------------
  Future<bool> _submit(BondViewModel vm) async {
    if (!isMultiple) {
      return vm.submitSingle(
        price: _priceCtrl.text.trim(),
        code: _bondCodeCtrl.text.trim(),
      );
    } else {
      return vm.submitBulk(
        price: _priceCtrl.text.trim(),
        startPrizeBondNumber: _startNumberCtrl.text.trim(),
        totalBond: _totalBondCtrl.text.trim(),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi_0029/data/models/hewan_model.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_bloc.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_event.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_state.dart';

class EditHewanPage extends StatefulWidget {
  final HewanModel hewan;
  const EditHewanPage({super.key, required this.hewan});

  @override
  State<EditHewanPage> createState() => _EditHewanPageState();
}

class _EditHewanPageState extends State<EditHewanPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _jenisController;
  late final TextEditingController _tanggalController;
  late final TextEditingController _hargaController;
  late String _statusSelected;
  final List<String> statusOptions = ['tersedia'];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.hewan.nama);
    _jenisController = TextEditingController(text: widget.hewan.jenis);
    _tanggalController = TextEditingController(text: widget.hewan.tanggalLahir);
    _hargaController = TextEditingController(
      text: widget.hewan.harga.toString(),
    );
    _statusSelected = widget.hewan.status;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _tanggalController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama': _namaController.text.trim(),
        'jenis': _jenisController.text.trim(),
        'tanggal_lahir': _tanggalController.text.trim(),
        'harga': int.tryParse(_hargaController.text.trim()) ?? 0,
        'status': _statusSelected,
      };
      context.read<HewanBloc>().add(UpdateHewan(widget.hewan.id, data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HewanBloc, HewanState>(
      listener: (context, state) {
        if (state is HewanCreatedSuccess) {
          Navigator.pop(context);
        } else if (state is HewanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            '✏️ Edit Data Hewan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFF2E7D32),
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2E7D32), Color(0xFF558B2F)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(_namaController, 'Nama', Icons.pets),
                    const SizedBox(height: 12),
                    _buildField(_jenisController, 'Jenis', Icons.category),
                    const SizedBox(height: 12),
                    _buildField(
                      _tanggalController,
                      'Tanggal Lahir (YYYY-MM-DD)',
                      Icons.calendar_today,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      _hargaController,
                      'Harga',
                      Icons.attach_money,
                      isNumber: true,
                    ),
                    const SizedBox(height: 12),
                    _buildStatusDropdown(),
                    const SizedBox(height: 24),
                    BlocBuilder<HewanBloc, HewanState>(
                      builder: (context, state) {
                        if (state is HewanLoading) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8D6E63),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'Simpan Perubahan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ],
                )
              ),
            ),
          ), 
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return '$label wajib diisi';
        if (isNumber && int.tryParse(value.trim()) == null) {
          return '$label harus berupa angka';
        }
        return null;
      },
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF8D6E63).withOpacity(0.5), width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.08),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: _statusSelected,
        dropdownColor: Color(0xFF2E7D32),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        underline: Container(),
        icon: const Icon(Icons.expand_more, color: Colors.white70),
        items: statusOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF4CAF50).withOpacity(0.4),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(value),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _statusSelected = newValue;
            });
          }
        },
      ),
    );
  }
}
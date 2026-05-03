import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late final TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.hewan.nama);
    _jenisController = TextEditingController(text: widget.hewan.jenis);
    _tanggalController = TextEditingController(text: widget.hewan.tanggalLahir);
    _hargaController = TextEditingController(
      text: widget.hewan.harga.toString(),
    );
    _statusController = TextEditingController(text: widget.hewan.status);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _tanggalController.dispose();
    _hargaController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama': _namaController.text.trim(),
        'jenis': _jenisController.text.trim(),
        'tanggalLahir': _tanggalController.text.trim(),
        'harga': int.tryParse(_hargaController.text.trim()) ?? 0,
        'status': _statusController.text.trim(),
      };
      context.read<HewanBloc>().add(UpdateHewan(widget.hewan.id, data));
    }
  }

  Widget build (BuildContext context) {
    return BlocListener<HewanBloc, HewanState> (
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
            'Edit Hewan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A237E), Color(0xFFAD1457)],
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
                    _buildField(_statusController, 'Status', Icons.info_outline),
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
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Perbarui',
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
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_bloc.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_event.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_state.dart';

class AddHewanPage extends StatefulWidget {
  const AddHewanPage({super.key});

  @override
  State<AddHewanPage> createState() => _AddHewanPageState();
}

class _AddHewanPageState extends State<AddHewanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jenisController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _hargaController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _tanggalLahirController.dispose();
    _hargaController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama': _namaController.text.trim(),
        'jenis': _jenisController.text.trim(),
        'tanggal_lahir': _tanggalLahirController.text.trim(),
        'harga': int.tryParse(_hargaController.text.trim()) ?? 0,
        'status': _statusController.text.trim()
      };
      context.read<HewanBloc>().add(CreateHewan(data));
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
            SnackBar(content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            "Tambah Hewan",
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: Colors.white
            ),
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
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(_namaController, 'Nama', Icons.pets),
                    const SizedBox(height: 12),
                    _buildField(_jenisController, 'Jenis', Icons.category),
                    const SizedBox(height: 12),
                    _buildField(_tanggalLahirController, 'Tanggal Lahir (DD-MM-YYYY)', Icons.calendar_today),
                    const SizedBox(height: 12),
                    _buildField(_hargaController, 'Harga', Icons.attach_money),
                    const SizedBox(height: 12),
                    _buildField(_statusController, 'Status', Icons.info_outline),
                    const SizedBox(height: 24),
                    BlocBuilder<HewanBloc, HewanState>(
                      builder: (context, state) {
                        if (state is HewanLoading) {
                          return const CircularProgressIndicator(color: Colors.white,);
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Simpan",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}
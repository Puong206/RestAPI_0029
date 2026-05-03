import 'package:flutter/material.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_bloc.dart';

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
}
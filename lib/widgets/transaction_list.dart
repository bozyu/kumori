import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction) onEdit;
  final Function(String) onDelete;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return transactions.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Нет транзакций',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.only(top: 0, bottom: 80),
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tx = transactions[index];
              return Dismissible(
                key: Key(tx.id),
                background: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 14,
                  ),
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Удалить',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.delete,
                        color: colorScheme.onError,
                        size: 28,
                      ),
                    ],
                  ),
                ),
                direction: DismissDirection.endToStart,
                dismissThresholds: const {
                  DismissDirection.endToStart: 0.6,
                },
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        title: Text(
                          'Подтверждение удаления',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Вы действительно хотите удалить транзакцию "${tx.title}"?',
                          style: textTheme.bodyLarge,
                        ),
                        actions: [
                          OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                            child: const Text('Отмена'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.onError,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                            child: const Text('Удалить'),
                          ),
                        ],
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actionsPadding:
                            const EdgeInsets.fromLTRB(24, 0, 24, 16),
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  onDelete(tx.id);
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 14,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: tx.isIncome
                      ? colorScheme.secondaryContainer
                      : colorScheme.secondaryContainer,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          tx.isIncome ? colorScheme.primary : colorScheme.error,
                      child: Icon(
                        tx.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                        color: tx.isIncome
                            ? colorScheme.onPrimary
                            : colorScheme.onError,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      tx.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd.MM.yyyy').format(tx.date),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        if (tx.notes != null && tx.notes!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              tx.notes!,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${tx.amount.toStringAsFixed(0)}Ӓ',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: tx.isIncome
                                ? colorScheme.primary
                                : colorScheme.error,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Icon(
                          Icons.swipe_left_alt,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                    onTap: () => onEdit(tx),
                  ),
                ),
              );
            },
          );
  }
}

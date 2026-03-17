# Database Migrations

This directory contains database migration files.

## Migration Files

When the database schema changes, migration files should be added here
to handle upgrading from previous versions.

## Naming Convention

Migration files should be named using the pattern:
`v{from}_to_v{to}_migration.sql`

For example:
- `v1_to_v2_migration.sql`

## Usage

Migrations are handled automatically by Drift. When you change the schema:

1. Increment `schemaVersion` in `database.dart`
2. Add migration code in the `onUpgrade` method
3. Test the migration thoroughly

## Example

```dart
@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Migration from v1 to v2
        await m.addColumn(users, users.newColumn);
      }
      if (from < 3) {
        // Migration from v2 to v3
        await m.createTable(newTable);
      }
    },
  );
}
```

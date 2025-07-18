## Naming Conventions

These are the conventions that (most likely) FAKT Software originally used when writing the game's code.

For convenience, not all the original conventions are used in the reference (these are noted with a strikethrough).

| Symbol | Meaning                         | Examples      |
|--------|---------------------------------|---------------|
| `{P}`  | Matches regex `[A-Z][A-Z,0-9]*` | `F`, `CM2`    |
| `{p}`  | Matches regex `[A-Z][a-z,0-9]*` | `Ft`, `Cm2`   |
| `{h}`  | Hungarian notation prefix       | `pfn`, `ap`   |
| `{e}`  | Enum name (may be shortened)    | `FMT`, `FLAG` |

| Identifier                     | Convention                   |
|--------------------------------|------------------------------|
| Static function                | `StaticMyFunc`               |
| Global exposed function        | `{p}MyFunc`                  |
| Global implementation function | `_{p}MyFunc`                 |
| Member function                | `MyFunc`                     |
| Static member function         | `StaticMyFunc`               |
| Class                          | `{P}MyClass`                 |
| Class template                 | `{P}TMyClass`                |
| Scoped struct                  | `MyStruct`                   |
| Global struct                  | `MYSTRUCT`                   |
| Enum                           | `MY_ENUM`                    |
| Macro                          | `MY_MACRO`                   |
| Enumerator                     | `{e}_VALUE`                  |
| Member                         | ~~`m_{h}MyVar`~~<br/>`myVar` |
| Static member                  | `ms_{h}MyVar`                |
| Global variable                | `g_{h}MyVar`                 |
| Static variable                | `s_{h}MyVar`                 |
| Local variable                 | `{h}MyVar`                   |

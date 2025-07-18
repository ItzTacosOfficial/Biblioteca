# Biblioteca

### Reverse engineered headers for Crazy Machines 2

> [!IMPORTANT]
> This is a hobby project and will not be maintained forever/full time.
> The project is far from finished, but due to the nature of the game this still opens some possibilities.
> Actual documentation of the libraries is most likely not happening any time soon.

## Usage

### Requirements

- MSVC VS 2022 (latest)
- CMake (3.25+)
- Steam copy of Crazy Machines 2

> [!NOTE]
> This project was made **exclusively** for the **DLC-less[^1] Steam build** of Crazy Machines 2.
> That is to provide support for the most accessible non-physical and up-to-date build of the game.

[^1]: Some DLCs such as _10th Anniversary_, replace the base game DLLs and may break compatibility.

### Building

In your project's `CMakeLists.txt`, add the root of this repository as a subdirectory:

```cmake
add_subdirectory("<Path to Biblioteca>")
```

If you installed Crazy Machines 2 regularly from Steam, Biblioteca should automatically detect the installation and find the game path.

Alternatively, you can manually specify the path by setting the CMake variable `BIBLIOTECA_GAME_PATH` accordingly before `add_subdirectory`.

Biblioteca will also verify the game's DLLs integrity, however the results can be optionally ignored by setting the CMake variable `BIBLIOTECA_IGNORE_HASH` to a true-value.

Now that the libraries are made available, you can link your application against the `faktum` and `cm2` targets:

```cmake
target_link_libraries(<Application> faktum cm2)
```

Upon building, the library files required for linking are going to get generated automatically in the `bin` folder of this repository.

Before compiling, make sure to set the C++ standard to 20 or above.[^2]

[^2]: A modern C++ standard is required due to possible library extensions.

## But why?

- Using the [Anfora](https://github.com/ItzTacosOfficial/Anfora) enviroment
- Writing tools interacting with faktum's FStorage format (`.fst`)
- *Also 'cause it's fun*

## Contributing

Header formatting should follow the scheme provided in [`docs/formatting.hpp`](/docs/formatting.hpp)

Naming conventions should match the table in [`docs/convention.md`](/docs/convention.md)

Commit messages should be formatted as `<FAK/CM2>: <Message>` (e.g. `FAK: Updated FObject`)

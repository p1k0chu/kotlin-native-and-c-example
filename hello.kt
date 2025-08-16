import org.example.*

@OptIn(kotlinx.cinterop.ExperimentalForeignApi::class)
fun print_hi() {
    println("Hello world")
    println(get_funny_number())
}


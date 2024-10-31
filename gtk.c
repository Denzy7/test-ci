
#include <gtk/gtk.h>

// Callback function for button click
static void on_button_clicked(GtkWidget *widget, gpointer data) {
    GtkWidget *dialog;
    GtkWindow *parent = GTK_WINDOW(data);

    // Create a new message dialog
    dialog = gtk_message_dialog_new(parent,
                                    GTK_DIALOG_DESTROY_WITH_PARENT,
                                    GTK_MESSAGE_INFO,
                                    GTK_BUTTONS_OK,
                                    "Hello, this is a message box!");

    // Show the dialog and wait for a response
    gtk_dialog_run(GTK_DIALOG(dialog));

    // Close the dialog when the response is received
    gtk_widget_destroy(dialog);
}

int main(int argc, char *argv[]) {
    GtkWidget *window;
    GtkWidget *button;

    // Initialize GTK
    gtk_init(&argc, &argv);

    // Create a new window
    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "Basic GTK+3 App");
    gtk_window_set_default_size(GTK_WINDOW(window), 300, 200);

    // Connect the destroy signal to close the window
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    // Create a new button
    button = gtk_button_new_with_label("Click Me");

    // Connect the button click signal to the callback function
    g_signal_connect(button, "clicked", G_CALLBACK(on_button_clicked), window);

    // Add the button to the window
    gtk_container_add(GTK_CONTAINER(window), button);

    // Show all widgets
    gtk_widget_show_all(window);

    // Start the GTK main loop
    gtk_main();

    return 0;
}

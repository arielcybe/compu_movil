# flutter_application_1

// Nombre de carpeta: flutter_application_1
// Descripción: Esta carpeta contiene la creación de una app móvil de reportes.
// Fecha de creación: 2024-11-30
// Autores: Alegría Cristobal, Guzmán Ariel, Pedreros Camilo 
// Versión: 1.0

## Getting Started

---------------------------------------------------------------------------------------------------------------------------------------

INSTRUCCIONES DE USO:
1) Clonar el repositorio en la rama Main
2) Abrir la carpeta 'flutter_application_1' desde el IDE de preferencia, idealmente Android Studio
3) Apretar alt + F12 para ingresar a la terminal del proyecto
4) Ingresar el siguiente comando 'flutter pub get' y esperar hasta que se complete la descarga de dependencias
5) Ingresar a https://api.sebastian.cl y obtener un token de uso de la Api
6) Ejecutar la App desde main.dart con flutter instalado en el emulador de preferencia
7) En la primera ventana de la App, se debe ingresar el token obtenido en el sitio web antes mencionado
8) Ya esta lista la app para su uso

NOTA: "Para mayor comodidad se creo la vista de ingreso de token debido a la duracion de 1 hora del mismo. En un caso real esta ventana no existiria"

---------------------------------------------------------------------------------------------------------------------------------------

CONSIDERACIONES IMPORTANTES:
API de Tickets: Las funciones fetchCategoriesFromApi() y fetchTicketsFromApi() son responsables de la llamada a la API para obtener los
    datos de las categorías y los tickets, respectivamente. Estas funciones no están definidas en el código proporcionado, por lo que es
    necesario implementar la lógica para conectarse a la API.

Estado de los Tickets: Los tickets pueden tener varios estados (RECEIVED, ERROR, UNDER_REVIEW, etc.), y el color del gradiente en el UI
    cambia según el tipo de ticket.

Gestión de Categorías: El menú desplegable de categorías permite seleccionar una categoría para ver los tickets asociados. Si no se 
    selecciona ninguna categoría, no se cargan los tickets.

Uso de Dialog para Mostrar Detalles: Los detalles de un ticket se muestran en un Dialog personalizado que utiliza un gradiente de 
    colores para diferenciar los tipos de ticket (INFORMATION, SUGGESTION, CLAIM).

---------------------------------------------------------------------------------------------------------------------------------------

Clase HistorialScreen:
Esta es la pantalla principal donde los usuarios pueden ver los tickets históricos. Los tickets se filtran por categorías,
    y la vista permite visualizar detalles de cada ticket en un diálogo emergente.

Propiedades:
String selectedCategory:
Almacena la categoría seleccionada por el usuario. Esta categoría se utiliza para filtrar los tickets a mostrar.

List<Category> categories:
Una lista de objetos Category que contiene todas las categorías disponibles. Estas categorías se obtienen de una API al cargar la
    pantalla.

List<Ticket> tickets:
Una lista de objetos Ticket que contiene los tickets filtrados según la categoría seleccionada. Estos tickets también se obtienen de una
    API.

Métodos:
initState(): Inicializa el estado de la pantalla, llamando a la función fetchCategories() para cargar las categorías desde la API al
    inicio.

fetchCategories(): Realiza una llamada a la API para obtener las categorías disponibles y las guarda en la lista categories. Si hay un
    error, se muestra en la consola.

fetchTickets(): Realiza una llamada a la API para obtener los tickets de la categoría seleccionada. Si no se ha seleccionado una
    categoría, se muestra un mensaje de error.

deleteTickets(): Esta función parece ser una repetición de fetchTickets() y se usa para recargar los tickets de la categoría seleccionada.
    Esta función no parece estar completada o implementada completamente.

showTicketDetails(Ticket ticket): Muestra un cuadro de diálogo con los detalles de un ticket. Incluye el asunto, el estado, los detalles
    del ticket y la fecha de creación, además de las opciones para gestionar el ticket según su estado (Aceptar, Rechazar o Cancelar
    solicitud).

Método build():
Construye la interfaz de usuario para la pantalla HistorialScreen, incluyendo:
-Un AppBar con un título y un gradiente de fondo.
-Un DropdownButtonFormField para seleccionar una categoría. Al seleccionar una categoría, se actualizan los tickets visibles.
-Una lista de tickets filtrados por la categoría seleccionada. Si no hay tickets, se muestra un mensaje.
-Cada ticket tiene un contenedor con un gradiente y puede ser tocado para ver los detalles en un cuadro de diálogo.

ErrorScreen (Pantalla de Error)
Clase ErrorScreen:
La clase ErrorScreen es responsable de mostrar un cuadro de diálogo con un mensaje de error en caso de que ocurra algún problema en la
    aplicación.

Método:
showErrorDialog(BuildContext context, String message): Muestra un cuadro de diálogo con el título "Error" y un mensaje proporcionado
    por el parámetro message. La acción del botón es cerrar el diálogo.

---------------------------------------------------------------------------------------------------------------------------------------

Dropdown (Desplegable): Permite al usuario seleccionar una categoría de las que se cargan desde la API. Al seleccionar una categoría,
    se actualizan los tickets mostrados.

Lista de Tickets: Se muestra una lista de tickets filtrados según la categoría seleccionada. Cada ticket está representado por un
    Container con un gradiente de color según el tipo de ticket (INFORMATION, SUGGESTION, CLAIM, etc.).

Detalles del Ticket: Al tocar un ticket, se muestra un cuadro de diálogo con información detallada sobre ese ticket, incluyendo el 
    estado, el asunto, los detalles y la fecha de creación. También se ofrecen opciones de gestión de tickets, como aceptar o rechazar
    la solución, o cancelar la solicitud.
















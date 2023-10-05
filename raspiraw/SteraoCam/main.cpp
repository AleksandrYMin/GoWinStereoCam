#include <wiringPi.h>

// Контакт LED — это контакт 0 wiringPi (BCM_GPIO 17).
// при инициализации с использованием wiringPiSetupSys нужно применять нумерацию BCM
// при выборе другого ПИН-кода используйте нумерацию BCM, также
// обновите команду "Страницы свойств" — "События сборки" — "Удаленное событие после сборки"
// , которая использует gpio export для настройки значений для wiringPiSetupSys
#define	LED	17


int main(void)
{
	wiringPiSetupSys();

	pinMode(LED, OUTPUT);

	while (true)
	{
		digitalWrite(LED, HIGH);  // Вкл.
		delay(500); // мс
		digitalWrite(LED, LOW);	  // Выкл.
		delay(500);
	}
	return 0;
}
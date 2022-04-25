package models

import (
	"log"
)

func init() {
	err := DB.Set(`gorm:table_options`, "charset=utf8mb4").AutoMigrate(&Order{})
	if err != nil {
		log.Println("gorm Init Error : ", err)
	}
}

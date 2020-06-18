macro BRU_BEGIN
	DB 'G'
	DB 'A'
	DB 'M'
	DB 'E'
	DB '$'
	DB ' '
	DB ' '
	DB ' '
	DW bru_start
	DW bru_size
	DB 80H
	DB 0
	DB 0
	DB 0
end macro

macro BRU_END
	while $ and 15 <> 0
		DB 0FFH
	end while
	bru_start = $$
	bru_size = $-$$
end macro

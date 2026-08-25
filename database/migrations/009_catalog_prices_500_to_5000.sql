-- Publish pricing for the additional catalog range (USD).
-- Prices are starting prices; final configuration and freight are quoted separately.

UPDATE products
SET price = CASE sku
    WHEN 'VP-INS-PT400' THEN 500.00
    WHEN 'VP-VLV-BF150' THEN 850.00
    WHEN 'VP-INS-CF25'  THEN 1200.00
    WHEN 'VP-VLV-GV300' THEN 1600.00
    WHEN 'VP-FLT-SC100' THEN 2200.00
    WHEN 'VP-HX-BP40'   THEN 2800.00
    WHEN 'VP-PMP-VT90'  THEN 3500.00
    WHEN 'VP-PMP-AP610' THEN 4000.00
    WHEN 'VP-FLT-FS800' THEN 4500.00
    WHEN 'VP-HX-ST500'  THEN 5000.00
END
WHERE sku IN ('VP-INS-PT400','VP-VLV-BF150','VP-INS-CF25','VP-VLV-GV300','VP-FLT-SC100','VP-HX-BP40','VP-PMP-VT90','VP-PMP-AP610','VP-FLT-FS800','VP-HX-ST500');

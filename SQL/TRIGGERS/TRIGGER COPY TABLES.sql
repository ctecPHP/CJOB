CREATE TRIGGER TRG_CPSA1990_SA1040 ON totvs12.dbo.SA1990
AFTER INSERT
AS
BEGIN
	INSERT INTO SA1040 SELECT * FROM SA1990 WHERE SA1990.R_E_C_N_O_ = ( SELECT R_E_C_N_O_ FROM inserted )
END	
GO

CREATE TRIGGER TRG_UPSA1990_SA1040 ON totvs12.dbo.SA1990
FOR UPDATE
AS
BEGIN 
	DELETE SA1040 WHERE SA1040.R_E_C_N_O_ = ( SELECT R_E_C_N_O_ FROM inserted)
    INSERT INTO SA1040 SELECT * FROM SA1990 WHERE SA1990.R_E_C_N_O_ = ( SELECT R_E_C_N_O_ FROM inserted )
END
GO


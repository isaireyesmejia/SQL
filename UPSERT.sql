CREATE PROCEDURE dbo.web_Tra_Upsert
@p_Adeudo INT
,@p_Matricula CHAR(8)
,@p_Concepto INT
,@p_Calendario INT

,@p_Amount DECIMAL(10,2)
,@p_ExpirationDate SMALLDATETIME
,@p_Type BIT
,@refArgosPayCash VARCHAR(50) OUTPUT
,@Reference CHAR(13) OUTPUT
,@ErrorCode TINYINT
,@ErrorMessage VARCHAR(500)
,@ReferenceBI BIT
,@MensajeError VARCHAR(500) OUTPUT

--SET @p_Adeudo=2546868
--SET @p_Matricula='LIC1860'
--SET @p_Concepto=1
--SET @p_Calendario=383

--SET @p_Amount='5.00'
--SET @p_ExpirationDate='20220730'
--SET @p_Type=1

--SET @Reference='1154202600049'
--SET @ErrorCode=0
--SET @ErrorMessage='Operacion Exitosa.'
AS
BEGIN

	SELECT @ErrorCode
	SET @refArgosPayCash='REFERENCIA ARGOS'
	SET @Reference='referencia paycash'

	--creamos la referencia que servirá para identificar el pago
	SELECT  @refArgosPayCash=
	(REPLICATE('0', (3 - LEN(cur.Clave_IN)))+convert(varchar(10),cur.Clave_IN)+
	REPLICATE('0', (4 - LEN(alu.Num_Serial_IN)))+convert(varchar(10),alu.Num_Serial_IN)+
	REPLICATE('0', (3 - LEN(ade.Concepto_IN)))+convert(varchar(10),ade.Concepto_IN)+
	REPLICATE('0', (3 - LEN(ISNULL(ade.Calendario_IN,0))))+convert(varchar(10),ISNULL(ade.Calendario_IN,0))+
	REPLICATE('0', (9 - LEN(ade.Adeudo_IN)))+convert(varchar(10),ade.Adeudo_IN)) 
	FROM T_Alumnos alu
	INNER JOIN T_Cursos cur
	ON alu.Curso_CH=cur.Curso_CH
	INNER JOIN T_Adeudos ade
	ON ade.Matricula_CH=alu.Matricula_CH
	WHERE Adeudo_IN=@p_Adeudo

	BEGIN TRY

		IF(ISNULL(@Reference,'')<>'')
			SET @ReferenceBI=1

		MERGE INTO T_PayCash AS pc
		USING (SELECT 
			@p_Adeudo,@p_Matricula,@p_Concepto,@p_Calendario,@p_Amount,@p_ExpirationDate,@p_Type
			,@Reference,@ErrorCode,@ErrorMessage,@ReferenceBI
			) AS c(Adeudo,Matricula,Concepto,Calendario,Amount,ExpirationDate,p_Type,
				Reference,ErrorCode,ErrorMessage,ReferenceBI)
		ON pc.Adeudo_IN=c.Adeudo
		WHEN MATCHED THEN
			UPDATE SET 
			pc.Reference=c.Reference
			,pc.ErrorCode=c.ErrorCode
			,pc.ErrorMessage=c.ErrorMessage
			,pc.ReferenceBI=c.ReferenceBI
		WHEN NOT MATCHED THEN
			INSERT (Adeudo_IN,Matricula_CH,Concepto_IN,Calendario_IN,Amount,ExpirationDate,ReferenciaArgos,Type)
			VALUES(c.Adeudo,c.Matricula,c.Concepto,c.Calendario,c.Amount,c.ExpirationDate,@refArgosPayCash,c.p_Type);

	END TRY
	BEGIN CATCH
		--select ERROR_NUMBER() As 'Nº de Error', 
		--ERROR_SEVERITY() As 'Severidad',
		--ERROR_STATE() As 'Estado', 
		--ERROR_PROCEDURE() As 'Procedimiento', 
		--ERROR_LINE() As 'Nº línea',
		SELECT @MensajeError=ERROR_MESSAGE()
	END CATCH
END
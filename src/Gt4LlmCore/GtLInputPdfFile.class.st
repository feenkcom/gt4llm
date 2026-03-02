Class {
	#name : #GtLInputPdfFile,
	#superclass : #GtLInputAttachment,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLInputPdfFile >> contentType [
		^ 'application/pdf'
]

{ #category : #serialization }
GtLInputPdfFile >> serializeToAnthropicResponseOutput [
	^ {
		'type' -> 'document'.
		'source'-> {
			'media_type' -> self contentType.
			'type' ->'base64'.
			'data' -> self base64EncodedContent } asDictionary}
			asDictionary
]

{ #category : #serialization }
GtLInputPdfFile >> serializeToOpenAIResponseOutput [
	^ {'type' -> 'input_file'.
		'filename' -> self fileReference basename.
		'file_data' -> ('data:'
				, self contentType 
				,';base64,' 
				, self base64EncodedContent)}
			asDictionary
]

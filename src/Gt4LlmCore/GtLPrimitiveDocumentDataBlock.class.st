"
I represent a document data block for LLM serialization, similar to GtLPrimitiveImageDataBlock but for documents like PDFs.
"
Class {
	#name : #GtLPrimitiveDocumentDataBlock,
	#superclass : #GtLPrimitiveDataBlock,
	#instVars : [
		'documentBytes',
		'contentType',
		'encodedBytes'
	],
	#category : 'Gt4LlmCore-Data Views'
}

{ #category : #accessing }
GtLPrimitiveDocumentDataBlock >> contentType [
	^ contentType
]

{ #category : #accessing }
GtLPrimitiveDocumentDataBlock >> contentType: anObject [
	contentType := anObject
]

{ #category : #printing }
GtLPrimitiveDocumentDataBlock >> descriptionOn: aStream [
	aStream << 'key: '.
	self dataKey 
		ifNil: [ aStream << '<none>' ]
		ifNotNil: [ aStream print: self dataKey ].
	aStream << '; type: '.
	aStream << (self contentType ifNil: [ '<none>' ])
]

{ #category : #accessing }
GtLPrimitiveDocumentDataBlock >> documentBytes [
	^ documentBytes
]

{ #category : #accessing }
GtLPrimitiveDocumentDataBlock >> documentBytes: anObject [
	documentBytes := anObject.
	encodedBytes := documentBytes base64Encoded.
]

{ #category : #accessing }
GtLPrimitiveDocumentDataBlock >> documentFormat [
	"Return the document format from the content type (e.g., 'application/pdf' -> 'pdf')"
	^ (self contentType 
			copyAfterLast: $/) ifEmpty: [ self contentType ]
]

{ #category : #accessing }
GtLPrimitiveDocumentDataBlock >> encodedBytes [
	^ encodedBytes
]

{ #category : #serialization }
GtLPrimitiveDocumentDataBlock >> serializeForAnthropic [
	<return: #Array of: #NeoJSONObject>
	<llmSerialization: #Anthropic>
	
	^ {NeoJSONObject new
		at: 'type' put: 'document';
		at: 'source' put: {
			'media_type' -> self contentType.
			'type' -> 'base64'.
			'data' -> self encodedBytes } asDictionary;
		yourself}
]

{ #category : #serialization }
GtLPrimitiveDocumentDataBlock >> serializeForBedrockConverse [
	"Return a JSON that represents tool response output."
	<sys_ext>
	<llmSerialization: #BedrockConverse>
	
	^ {{
		'document' -> {
			'format' -> self documentFormat.
			'source' -> {'bytes' -> self encodedBytes} asDictionary } asDictionary}
			asDictionary}
]

{ #category : #serialization }
GtLPrimitiveDocumentDataBlock >> serializeForOpenAI [
	<return: #Array of: #NeoJSONObject>
	<llmSerialization: #OpenAI>
	
	^ {NeoJSONObject new
		at: 'type' put: 'input_file';
		at: 'file_data' put: ('data:', self contentType, ';base64,', self encodedBytes);
		yourself}
]

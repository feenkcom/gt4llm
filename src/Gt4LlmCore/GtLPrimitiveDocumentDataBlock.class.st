"
I represent a document data block for LLM serialization, similar to GtLPrimitiveImageDataBlock but for documents like PDFs.
"
Class {
	#name : #GtLPrimitiveDocumentDataBlock,
	#superclass : #GtLPrimitiveDataBlock,
	#instVars : [
		'documentBytes',
		'contentType',
		'encodedBytes',
		'contentLabel'
	],
	#category : 'Gt4LlmCore-Data Views'
}

{ #category : #visiting }
GtLPrimitiveDocumentDataBlock >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLPrimitiveDocumentDataBlock: self
]

{ #category : #accessing }
GtLPrimitiveDocumentDataBlock >> contentLabel [
	^contentLabel
]

{ #category : #accessing }
GtLPrimitiveDocumentDataBlock >> contentLabel: anObject [
	contentLabel := anObject
]

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
	
	^ {NeoJSONObject new
		at: 'type' put: 'document';
		at: 'source' put: {
			'media_type' -> self contentType.
			'type' -> 'base64'.
			'data' -> self encodedBytes } asDictionary;
		yourself}
]

{ #category : #serialization }
GtLPrimitiveDocumentDataBlock >> serializeForMCP [
	<return: #Array of: #NeoJSONObject>
	
	^ {NeoJSONObject new
		at: 'type' put: 'resource';
		at: 'resource' put: {
			'mimeType' -> self contentType.
			'uri' -> ('mcp://resources/',self identityHash asString).
			'blob' -> self encodedBytes } asDictionary;
		yourself}
]

{ #category : #serialization }
GtLPrimitiveDocumentDataBlock >> serializeForOllamaGenerate [
	<return: #Array of: #NeoJSONObject>

	^ {NeoJSONObject new
		at: 'type' put: 'input_file';
		at: 'file_data' put: ('data:', self contentType, ';base64,', self encodedBytes);
		yourself}
]

{ #category : #serialization }
GtLPrimitiveDocumentDataBlock >> serializeForOllamaOpenAi [
	<return: #Array of: #NeoJSONObject>

	^ {NeoJSONObject new
			at: 'type' put: 'file_data';
			at: 'file_data' put: ('data:', self contentType, ';base64,', self encodedBytes);
		yourself}
]

{ #category : #serialization }
GtLPrimitiveDocumentDataBlock >> serializeForOpenAI [
	<return: #Array of: #NeoJSONObject>
	| resultData  |
	
	resultData := NeoJSONObject new
			at: 'type' put: 'input_file';
			at: 'file_data' 
				put: ('data:', self contentType, ';base64,', self encodedBytes);
		yourself.
		
	self contentLabel ifNotNil: [ :aValue |
		resultData
			at: 'filename' 
			put: (self contentLabel ifNil: [ 'document' ])].
	
	^ {resultData}
]

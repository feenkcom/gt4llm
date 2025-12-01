Class {
	#name : #GtLOpenAIFile,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'purpose',
		'filename',
		'bytes',
		'createdAt',
		'status',
		'statusDetails'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIFile class >> leJsonV4Name [

	^ #gtOpenAIFile
]

{ #category : #accessing }
GtLOpenAIFile class >> serializationProperties [
	^ {#id -> #id.
		#purpose -> #purpose.
		#filename -> #filename.
		#bytes -> #bytes.
		#created_at -> #createdAt.
		#status -> #status.
		#status_details -> #statusDetails}
]

{ #category : #accessing }
GtLOpenAIFile >> bytes [
	^ bytes
]

{ #category : #accessing }
GtLOpenAIFile >> bytes: anObject [
	bytes := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIFile >> contents [
	^ (FileSystem memory / self filename) ensureCreateFile
		binaryWriteStreamDo: [ :aStream | aStream nextPutAll: (self client getFileContents: self id) ];
		yourself
]

{ #category : #accessing }
GtLOpenAIFile >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIFile >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIFile >> filename [
	^ filename
]

{ #category : #accessing }
GtLOpenAIFile >> filename: anObject [
	filename := anObject
]

{ #category : #'gt - extensions' }
GtLOpenAIFile >> gtFileFor: aView [
	<gtView>
	^ aView explicit
		title: 'File';
		priority: 1;
		stencil: [ (self contents gtViewsFor: GtPhlowEmptyView new)
				asElementDo: [ :e | 
					e
						margin: (BlInsets all: 15);
						background: Color white;
						addAptitude: BrShadowAptitude ] ]
]

{ #category : #accessing }
GtLOpenAIFile >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIFile >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIFile >> isAssistantsOutput [
	^ self purpose = 'assistants-output'
]

{ #category : #accessing }
GtLOpenAIFile >> isError [
	^ self status = 'error'
]

{ #category : #accessing }
GtLOpenAIFile >> isFinetuningResults [
	^ self purpose = 'fine-tune-results'
]

{ #category : #accessing }
GtLOpenAIFile >> isForAssistants [
	^ self purpose = 'assistants'
]

{ #category : #accessing }
GtLOpenAIFile >> isForFinetuning [
	^ self purpose = 'fine-tune'
]

{ #category : #accessing }
GtLOpenAIFile >> isProcessed [
	^ self status = 'processed'
]

{ #category : #accessing }
GtLOpenAIFile >> isUploaded [
	^ self status = 'uploaded'
]

{ #category : #accessing }
GtLOpenAIFile >> purpose [
	^ purpose
]

{ #category : #accessing }
GtLOpenAIFile >> purpose: anObject [
	purpose := anObject
]

{ #category : #accessing }
GtLOpenAIFile >> status [
	^ status
]

{ #category : #accessing }
GtLOpenAIFile >> status: anObject [
	status := anObject
]

{ #category : #accessing }
GtLOpenAIFile >> statusDetails [
	^ statusDetails
]

{ #category : #accessing }
GtLOpenAIFile >> statusDetails: anObject [
	statusDetails := anObject
]

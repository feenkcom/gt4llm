Class {
	#name : #GtLToolForWorldScreenshot,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'worldElementProvider',
		'pngDataProvider'
	],
	#category : #Gt4LlmCore
}

{ #category : #'as yet unclassified' }
GtLToolForWorldScreenshot class >> leJsonV4Name [
	^ #gtLToolForWorldScreenshot
]

{ #category : #private }
GtLToolForWorldScreenshot >> binaryContentsOf: aFileReference [
	| stream |
	stream := aFileReference binaryReadStream.
	^ [ stream contents ] ensure: [ stream close ]
]

{ #category : #private }
GtLToolForWorldScreenshot >> defaultFocusedWorldElement [
	^ GtWorldElement allInstances
		detect: [ :each | self isCapturableWorldElement: each ]
		ifNone: [ nil ]
]

{ #category : #private }
GtLToolForWorldScreenshot >> deleteFileReferenceIfPossible: aFileReference [
	aFileReference ifNil: [ ^ self ].
	[ aFileReference ensureDelete ] on: Error do: [ :ignored | ignored ]
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> description [
	^ 'Capture the currently focused GtWorldElement as a PNG screenshot and return the Base64 data.'
]

{ #category : #private }
GtLToolForWorldScreenshot >> exportFormOf: aWorldElement [
	^ self pngExporter
		element: aWorldElement;
		doExport: [ :aCanvas | aCanvas asForm ]
]

{ #category : #private }
GtLToolForWorldScreenshot >> exportScreenshotOf: aWorldElement [
	^ self pngExporter
		element: aWorldElement;
		export
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> focusedWorldElement [
	^ self worldElementProvider
		ifNotNil: [ :provider | provider value ]
		ifNil: [ self defaultFocusedWorldElement ]
]

{ #category : #testing }
GtLToolForWorldScreenshot >> isCapturableWorldElement: aWorldElement [
	^ [ aWorldElement space notNil and: [ aWorldElement space isFocused ] ]
		on: Error
		do: [ false ]
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> name [
	^ 'worldScreenshot'
]

{ #category : #private }
GtLToolForWorldScreenshot >> noFocusedWorldDomainObject [
	^ GtLProblemDomainObject new
		description: 'No focused GtWorldElement is currently available for capturing a screenshot.';
		yourself
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> parameters [
	^ #()
]

{ #category : #private }
GtLToolForWorldScreenshot >> pngDataFor: aWorldElement [
	^ self pngDataProvider
		ifNotNil: [ :provider | provider value ]
		ifNil: [ | form |
			form := self exportFormOf: aWorldElement.
			self pngDataFromForm: form ]
]

{ #category : #private }
GtLToolForWorldScreenshot >> pngDataFromForm: aForm [
	^ ByteArray streamContents: [ :out | self pngReadWriterClass putForm: aForm onStream: out ]
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> pngDataProvider [
	^ pngDataProvider
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> pngDataProvider: aBlock [
	pngDataProvider := aBlock
]

{ #category : #private }
GtLToolForWorldScreenshot >> pngExporter [
	^ BlExporter png
]

{ #category : #private }
GtLToolForWorldScreenshot >> pngReadWriterClass [
	^ PNGReadWriter
]

{ #category : #private }
GtLToolForWorldScreenshot >> privatePerformToolCall: aToolCall [
	| worldElement pngData |
	worldElement := self focusedWorldElement.
	worldElement ifNil: [ ^ self noFocusedWorldDomainObject ].
	^ [ pngData := self pngDataFor: worldElement.
		self screenshotDomainObjectFor: pngData ]
		on: Error
		do: [ :ex |
			GtLExceptionDomainObject new
				freeze: ex;
				description: 'Failed to capture a GtWorldElement screenshot' ]
]

{ #category : #private }
GtLToolForWorldScreenshot >> screenshotDomainObjectFor: pngData [
	^ GtLWorldScreenshotDomainObject new
		fileName: 'world.png';
		data: pngData;
		yourself
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> worldElementProvider [
	^ worldElementProvider
]

{ #category : #accessing }
GtLToolForWorldScreenshot >> worldElementProvider: aBlock [
	worldElementProvider := aBlock
]

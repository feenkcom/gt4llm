"
Examples for GtLObjectValueResult testing serialization and data views.
"
Class {
	#name : #GtLObjectValueResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#instVars : [
		'theDatabase'
	],
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #assertions }
GtLObjectValueResultExamples >> assertObjectValueJson: objectValueJson includesPhlowViews: expectedMethodNames [
	"Assert that the object value JSON includes the expected phlow view method names"
	| phlowViews phlowViewMethodNames |
	phlowViews := objectValueJson at: 'phlowViews'.
	self assert: phlowViews isNotEmpty.
	phlowViewMethodNames := phlowViews collect: [ :each | each at: 'methodName' ].
	expectedMethodNames do: [ :methodName |
		self assert: (phlowViewMethodNames includes: methodName) ]
]

{ #category : #asserting }
GtLObjectValueResultExamples >> assertObjectValueResultJsonDataKeys: jsonData [
	"Assert that the JSON data contains the expected keys for an object value result"
	| expectedKeys expectedObjectValueKeys objectValueJson |
	expectedKeys := #('objectDetails' #objectValue #playgroundPageReference).
	self assert: jsonData keys sorted equals: expectedKeys sorted.
	
	objectValueJson := jsonData at: #objectValue.
	expectedObjectValueKeys := #(#allInstanceSlots #objectClassName #objectPrintString #packageName #phlowViews #superclassName).
	self assert: objectValueJson keys sorted equals: expectedObjectValueKeys sorted
]

{ #category : #private }
GtLObjectValueResultExamples >> expectedPlaygroundPageReferenceForInteger [
	^ self expectedPlaygroundPageReferenceForObjectClassName: 'SmallInteger'
]

{ #category : #private }
GtLObjectValueResultExamples >> expectedPlaygroundPageReferenceForObjectClassName: aClassName [
	| page expectedTitle |
	expectedTitle := aClassName , ' Page'.
	page := self theDatabase pages detect: [ :each | each title = expectedTitle ].
	^ NeoJSONObject new
		at: 'databaseId' put: self theDatabase primaryDB uuidString;
		at: 'pageId' put: page uid asString36;
		yourself
]

{ #category : #private }
GtLObjectValueResultExamples >> expectedPlaygroundPageReferenceForString [
	^ self expectedPlaygroundPageReferenceForObjectClassName: 'ByteString'
]

{ #category : #private }
GtLObjectValueResultExamples >> expectedPlaygroundPageReferenceForTestObject [
	^ self expectedPlaygroundPageReferenceForObjectClassName: GtLSerializedObjectValueTestObject name
]

{ #category : #initialization }
GtLObjectValueResultExamples >> initialize [
	super initialize.
	theDatabase := nil
]

{ #category : #private }
GtLObjectValueResultExamples >> lepiterPageReferenceForInteger: anObject [
	^ self
		lepiterPageReferenceForObject: anObject
		withSnippetCode: '42'
]

{ #category : #private }
GtLObjectValueResultExamples >> lepiterPageReferenceForObject: anObject withSnippetCode: aString [
	| page snippet |
	page := LePage pharoClassName: anObject class name.
	snippet := LePharoSnippet new.
	snippet code: aString.
	page addSnippet: snippet.
	self theDatabase addPage: page.
	self assert: page children size equals: 1.
	^ GtLLepiterPageReference new
		page: page;
		yourself
]

{ #category : #private }
GtLObjectValueResultExamples >> lepiterPageReferenceForString: anObject [
	^ self
		lepiterPageReferenceForObject: anObject
		withSnippetCode: '''hello world'''
]

{ #category : #private }
GtLObjectValueResultExamples >> lepiterPageReferenceForTestObject: anObject [
	^ self
		lepiterPageReferenceForObject: anObject
		withSnippetCode: 'GtLSerializedObjectValueTestObject exampleInstance'
]

{ #category : #examples }
GtLObjectValueResultExamples >> objectValueResultForInteger [
	<gtExample>
	<return: #GtLObjectValueResult>
	| object domainObject |
	object := 42.
	domainObject := GtLObjectValueResult forObject: object.
	domainObject playgroundPageReference: (self lepiterPageReferenceForInteger: object).
	self assert: domainObject object equals: object.
	self assert: domainObject objectValue class equals: GtLSerializedObjectValue.
	self assert: domainObject playgroundPageReference notNil.
	^ domainObject
]

{ #category : #examples }
GtLObjectValueResultExamples >> objectValueResultForIntegerMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| domainObject mainDataView forwardedView |
	domainObject := self objectValueResultForInteger.
	mainDataView := domainObject llmDataViewsFor: GtLDataView new.
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 2.
	self assertCompositeView: mainDataView hasJsonForwardDataViewWithDataKey: 'objectDetails' targetObject: domainObject object.
	forwardedView := (mainDataView dataViews detect: [ :each | each class = GtLForwardObjectDataView ]) computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 0.
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	^ mainDataView
]

{ #category : #examples }
GtLObjectValueResultExamples >> objectValueResultForIntegerSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData objectValueJson |
	mainDataView := self objectValueResultForIntegerMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	jsonData := dataBlock llmJsonData.
	self assertObjectValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: 'objectDetails') equals: Dictionary new.
	self assert: (jsonData at: #playgroundPageReference) equals: self expectedPlaygroundPageReferenceForInteger.
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'SmallInteger'.
	self assert: (objectValueJson at: 'objectPrintString') equals: '42'.
	self assert: (objectValueJson at: 'superclassName') equals: 'Integer'.
	self assert: (objectValueJson at: 'packageName') equals: 'Kernel'.
	self assert: (objectValueJson at: 'allInstanceSlots') asArray equals: #().
	self assertObjectValueJson: objectValueJson includesPhlowViews: #('gtPreviewFor:' 'gtIntegerFor:' 'gtRawFor:' 'gtPrintFor:').
	^ dataBlock
]

{ #category : #examples }
GtLObjectValueResultExamples >> objectValueResultForIntegerWithoutLepiterPageReference [
	<gtExample>
	<return: #GtLObjectValueResult>
	| object domainObject |
	object := 42.
	domainObject := GtLObjectValueResult forObject: object.
	self assert: domainObject object equals: object.
	self assert: domainObject objectValue class equals: GtLSerializedObjectValue.
	self assert: domainObject playgroundPageReference isNil.
	^ domainObject
]

{ #category : #examples }
GtLObjectValueResultExamples >> objectValueResultForString [
	<gtExample>
	<return: #GtLObjectValueResult>
	| object domainObject |
	object := 'hello world'.
	domainObject := GtLObjectValueResult forObject: object.
	domainObject playgroundPageReference: (self lepiterPageReferenceForString: object).
	self assert: domainObject object equals: object.
	self assert: domainObject objectValue class equals: GtLSerializedObjectValue.
	self assert: domainObject playgroundPageReference notNil.
	^ domainObject
]

{ #category : #'examples - views' }
GtLObjectValueResultExamples >> objectValueResultForStringMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| domainObject mainDataView forwardedView |
	
	domainObject := self objectValueResultForString.
	mainDataView := domainObject llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 2.
	
	"First view is forward for object specific details"
	self assertCompositeView: mainDataView hasJsonForwardDataViewWithDataKey: 'objectDetails' targetObject:  domainObject object.
	
	forwardedView := (mainDataView dataViews 
		detect: [ :each | each class = GtLForwardObjectDataView ]) computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 0.
	
	"Second view is raw data (magritte)"
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #examples }
GtLObjectValueResultExamples >> objectValueResultForStringSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData objectValueJson |
	
	mainDataView := self objectValueResultForStringMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assertObjectValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: 'objectDetails') isEmpty.
	self assert: (jsonData at: #playgroundPageReference) equals: self expectedPlaygroundPageReferenceForString.
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'ByteString'.
	self assert: (objectValueJson at: 'superclassName') equals: 'String'.
	self assert: (objectValueJson at: 'packageName') equals: 'Collections-Strings'.
	self assert: (objectValueJson at: 'allInstanceSlots') isEmpty.
	self assertObjectValueJson: objectValueJson includesPhlowViews: #('gtPrintFor:' 'gtRawFor:' 'gtStringFor:').
	
	^ dataBlock
]

{ #category : #examples }
GtLObjectValueResultExamples >> objectValueResultForTestObject [
	<gtExample>
	<return: #GtLObjectValueResult>
	| testObject domainObject |
	
	testObject := GtLSerializedObjectValueTestObject exampleInstance.
	domainObject := GtLObjectValueResult forObject: testObject.
	domainObject playgroundPageReference: (self lepiterPageReferenceForTestObject: testObject).
	
	self assert: domainObject object equals: testObject.
	self assert: domainObject objectValue class equals: GtLSerializedObjectValue.
	self assert: domainObject playgroundPageReference notNil.
	
	^ domainObject
]

{ #category : #'examples - views' }
GtLObjectValueResultExamples >> objectValueResultForTestObjectMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| domainObject mainDataView forwardedView |
	
	domainObject := self objectValueResultForTestObject.
	mainDataView := domainObject llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 2.
	
	self assertCompositeView: mainDataView hasJsonForwardDataViewWithDataKey: 'objectDetails' targetObject:  domainObject object.
	
	forwardedView := (mainDataView dataViews 
		detect: [ :each | each class = GtLForwardObjectDataView ]) computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 0.
	
	"Second view is raw data (magritte)"
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #examples }
GtLObjectValueResultExamples >> objectValueResultForTestObjectSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData objectValueJson slotsJson |
	
	mainDataView := self objectValueResultForTestObjectMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assertObjectValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: 'objectDetails') equals: Dictionary new.
	self assert: (jsonData at: #playgroundPageReference) equals: self expectedPlaygroundPageReferenceForTestObject.
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'GtLSerializedObjectValueTestObject'.
	self assert: (objectValueJson at: 'superclassName') equals: 'Object'.
	self assert: (objectValueJson at: 'packageName') equals: 'Gt4LlmCore-Examples'.
	
	slotsJson := objectValueJson at: 'allInstanceSlots'.
	self assert: slotsJson size equals: 3.
	self assert: (slotsJson first at: 'name') equals: 'name'.
	self assert: (slotsJson first at: 'valueClassName') equals: 'ByteString'.
	self assert: (slotsJson first at: 'valuePrintString') equals: 'TestObject'.
	self assert: (slotsJson second at: 'name') equals: 'count'.
	self assert: (slotsJson second at: 'valuePrintString') equals: '42'.
	self assert: (slotsJson third at: 'name') equals: 'items'.
	self assert: (slotsJson third at: 'valueClassName') equals: 'Array'.
	
	self assertObjectValueJson: objectValueJson includesPhlowViews: #('gtDetailsFor:' 'gtItemsFor:' 'gtRawFor:' 'gtPrintFor:').
	
	^ dataBlock
]

{ #category : #accessing }
GtLObjectValueResultExamples >> theDatabase [
	^ theDatabase ifNil: [
		| db |
		db := LeExplicitlyAttachedLinksExamples new emptyDatabase.
		theDatabase := LeLogicalDatabase new primaryDB: db ]
]

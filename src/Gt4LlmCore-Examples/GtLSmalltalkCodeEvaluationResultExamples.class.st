"
Examples for GtLSmalltalkCodeEvaluationResult and related domain objects.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#instVars : [
		'theDatabase'
	],
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #private }
GtLSmalltalkCodeEvaluationResultExamples >> expectedSimpleObjectValueJson [
	| expectedPhlowViews |
	expectedPhlowViews := NeoJSONArray with: (NeoJSONObject new
		at: 'methodName' put: 'gtPrintFor:';
		at: 'title' put: 'Print';
		yourself).
	^ NeoJSONObject new
		at: 'allInstanceSlots' put: NeoJSONArray new;
		at: 'objectClassName' put: 'SmallInteger';
		at: 'objectPrintString' put: '3';
		at: 'packageName' put: 'Kernel';
		at: 'phlowViews' put: expectedPhlowViews;
		at: 'superclassName' put: 'Integer';
		yourself
]

{ #category : #private }
GtLSmalltalkCodeEvaluationResultExamples >> expectedSimpleResultJsonData [
	^ Dictionary new
		at: #code put: '1 + 2';
		at: 'objectDetails' put: Dictionary new;
		at: #objectId put: 'test-uuid-123';
		at: #objectValue put: self expectedSimpleObjectValueJson;
		yourself
]

{ #category : #private }
GtLSmalltalkCodeEvaluationResultExamples >> lepiterPageReferenceForObject: anObject withSnippetCode: aString [
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

{ #category : #examples }
GtLSmalltalkCodeEvaluationResultExamples >> resultWithLepiterPageReference [
	<gtExample>
	<return: #GtLSmalltalkCodeEvaluationResult>
	| result |
	result := GtLSmalltalkCodeEvaluationResult
		forObject: 3
		withId: 'test-uuid-123'
		code: '1 + 2'
		playgroundPageReference: (self lepiterPageReferenceForObject: 3 withSnippetCode: '1 + 2').
	result objectValue: self simpleObjectValue.
	self assert: result playgroundPageReference notNil.
	^ result
]

{ #category : #examples }
GtLSmalltalkCodeEvaluationResultExamples >> resultWithLepiterPageReferenceDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| result compositeView dataBlock jsonData expectedPlaygroundPageReference expectedJson page |
	result := self resultWithLepiterPageReference.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	page := self theDatabase pages detect: [ :each | each title = 'SmallInteger Page' ].
	
	expectedPlaygroundPageReference := NeoJSONObject new
		at: 'databaseId' put: self theDatabase primaryDB uuidString;
		at: 'pageId' put: page uid asString36;
		yourself.
	
	expectedJson := self expectedSimpleResultJsonData 
		at: #playgroundPageReference put: expectedPlaygroundPageReference;
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #'examples - supporting' }
GtLSmalltalkCodeEvaluationResultExamples >> simpleObjectValue [
	<gtExample>
	^ GtLSerializedObjectValueExamples new simpleObjectValue
]

{ #category : #examples }
GtLSmalltalkCodeEvaluationResultExamples >> simpleResult [
	<gtExample>
	<return: #GtLSmalltalkCodeEvaluationResult>
	| result |
	result := GtLSmalltalkCodeEvaluationResult new
		code: '1 + 2';
		object: 3;
		objectValue: self simpleObjectValue;
		objectId: 'test-uuid-123';
		yourself.
	
	self assert: result code equals: '1 + 2'.
	self assert: result object equals: 3.
	self assert: result objectId equals: 'test-uuid-123'.
	self assert: result objectValue objectClassName equals: 'SmallInteger'.
	
	^ result
]

{ #category : #examples }
GtLSmalltalkCodeEvaluationResultExamples >> simpleResultDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| result compositeView dataBlock jsonData expectedJson |
	result := self simpleResult.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := self expectedSimpleResultJsonData 
		at: #playgroundPageReference put: nil;
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResultExamples >> theDatabase [
	^ theDatabase ifNil: [
		| db |
		db := LeExplicitlyAttachedLinksExamples new emptyDatabase.
		theDatabase := LeLogicalDatabase new primaryDB: db ]
]

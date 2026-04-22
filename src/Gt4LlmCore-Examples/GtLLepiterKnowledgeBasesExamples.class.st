"
Examples for GtLLepiterKnowledgeBases and GtLLepiterKnowledgeBase.
"
Class {
	#name : #GtLLepiterKnowledgeBasesExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLLepiterKnowledgeBasesExamples >> basicKnowledgeBase [
	<gtExample>
	| knowledgeBase |
	knowledgeBase := GtLLepiterKnowledgeBase new
		databaseName: 'TestDatabase';
		uuidString: '12345678-1234-1234-1234-123456789abc';
		pageCount: 42;
		storeLocation: '/path/to/store'.
	
	self assert: knowledgeBase databaseName equals: 'TestDatabase'.
	self assert: knowledgeBase uuidString equals: '12345678-1234-1234-1234-123456789abc'.
	self assert: knowledgeBase pageCount equals: 42.
	self assert: knowledgeBase storeLocation equals: '/path/to/store'.
	
	^ knowledgeBase
]

{ #category : #examples }
GtLLepiterKnowledgeBasesExamples >> basicKnowledgeBases [
	<gtExample>
	| knowledgeBases |
	knowledgeBases := GtLLepiterKnowledgeBases new
		knowledgeBases: { self basicKnowledgeBase }.
	
	self assert: knowledgeBases knowledgeBases size equals: 1.
	self assert: knowledgeBases knowledgeBases first databaseName equals: 'TestDatabase'.
	
	^ knowledgeBases
]

{ #category : #examples }
GtLLepiterKnowledgeBasesExamples >> knowledgeBaseDataViewSerialization [
	<gtExample>
	| knowledgeBase compositeView dataBlock expected |
	knowledgeBase := self basicKnowledgeBase.
	compositeView := knowledgeBase llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expected := Dictionary new
		at: #databaseName put: 'TestDatabase';
		at: #uuidString put: '12345678-1234-1234-1234-123456789abc';
		at: #pageCount put: 42;
		at: #storeLocation put: '/path/to/store';
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]

{ #category : #examples }
GtLLepiterKnowledgeBasesExamples >> knowledgeBasesDataViewSerialization [
	<gtExample>
	| knowledgeBases compositeView dataBlock expected |
	knowledgeBases := self basicKnowledgeBases.
	compositeView := knowledgeBases llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expected := Dictionary new
		at: #knowledgeBases put: (NeoJSONArray with: (NeoJSONObject new
			at: #databaseName put: 'TestDatabase';
			at: #uuidString put: '12345678-1234-1234-1234-123456789abc';
			at: #pageCount put: 42;
			at: #storeLocation put: '/path/to/store';
			yourself));
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]

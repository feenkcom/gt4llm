"
Examples for GtLLepiterSnippetDomainObject and its subclasses.
"
Class {
	#name : #GtLLepiterSnippetDomainObjectExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Magritte Objects'
}

{ #category : #examples }
GtLLepiterSnippetDomainObjectExamples >> basicSnippetDomainObject [
	<gtExample>
	| domainObject |
	domainObject := GtLLepiterSnippetDomainObject new
		status: 'created';
		pageUid: 'test-page-uid';
		snippetUid: 'test-snippet-uid'.
	
	self assert: domainObject status equals: 'created'.
	self assert: domainObject pageUid equals: 'test-page-uid'.
	self assert: domainObject snippetUid equals: 'test-snippet-uid'.
	
	^ domainObject
]

{ #category : #examples }
GtLLepiterSnippetDomainObjectExamples >> basicSnippetEditDomainObject [
	<gtExample>
	| domainObject |
	domainObject := GtLLepiterSnippetEditDomainObject new
		status: 'updated';
		pageUid: 'test-page-uid';
		snippetUid: 'test-snippet-uid';
		oldText: 'Old content'.
	
	self assert: domainObject status equals: 'updated'.
	self assert: domainObject pageUid equals: 'test-page-uid'.
	self assert: domainObject snippetUid equals: 'test-snippet-uid'.
	self assert: domainObject oldText equals: 'Old content'.
	
	^ domainObject
]

{ #category : #examples }
GtLLepiterSnippetDomainObjectExamples >> basicSnippetsDomainObject [
	<gtExample>
	| domainObject snippets |
	snippets := {
		GtLLepiterSnippetDomainObject new
			status: 'created';
			pageUid: 'page-uid-1';
			snippetUid: 'snippet-uid-1'.
		GtLLepiterSnippetDomainObject new
			status: 'created';
			pageUid: 'page-uid-2';
			snippetUid: 'snippet-uid-2'
	}.
	domainObject := GtLLepiterSnippetsDomainObject new
		snippets: snippets.
	
	self assert: domainObject snippets size equals: 2.
	self assert: domainObject snippets first status equals: 'created'.
	self assert: domainObject snippets second snippetUid equals: 'snippet-uid-2'.
	
	^ domainObject
]

{ #category : #'examples - serialization' }
GtLLepiterSnippetDomainObjectExamples >> snippetDomainObjectDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self basicSnippetDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := Dictionary new
		at: #status put: 'created';
		at: #pageUid put: 'test-page-uid';
		at: #snippetUid put: 'test-snippet-uid';
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]

{ #category : #'examples - serialization' }
GtLLepiterSnippetDomainObjectExamples >> snippetEditDomainObjectDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self basicSnippetEditDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := Dictionary new
		at: #status put: 'updated';
		at: #pageUid put: 'test-page-uid';
		at: #snippetUid put: 'test-snippet-uid';
		at: #oldText put: 'Old content';
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]

{ #category : #'examples - serialization' }
GtLLepiterSnippetDomainObjectExamples >> snippetsDomainObjectDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self basicSnippetsDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := Dictionary new
		at: #snippets put: (NeoJSONArray withAll: {
			NeoJSONObject new
				at: #status put: 'created';
				at: #pageUid put: 'page-uid-1';
				at: #snippetUid put: 'snippet-uid-1';
				yourself.
			NeoJSONObject new
				at: #status put: 'created';
				at: #pageUid put: 'page-uid-2';
				at: #snippetUid put: 'snippet-uid-2';
				yourself });
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]

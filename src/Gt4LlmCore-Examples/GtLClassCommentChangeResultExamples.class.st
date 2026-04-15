Class {
	#name : #GtLClassCommentChangeResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassCommentChangeResultExamples >> basicClassCommentChangeResult [
	<gtExample>
	<return: #GtLClassCommentChangeResult>
	| result |
	result := GtLClassCommentChangeResult new
		updatedClass: Object;
		status: 'changed';
		oldClassComment: 'Old class comment';
		newClassComment: 'New class comment';
		yourself.
	self assert: result changedClassName equals: 'Object'.
	self assert: result status equals: 'changed'.
	self assert: result oldClassComment equals: 'Old class comment'.
	self assert: result newClassComment equals: 'New class comment'.
	^ result
]

{ #category : #examples }
GtLClassCommentChangeResultExamples >> classCommentChangeDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| result compositeView dataBlock jsonData expectedJson |
	
	result := self basicClassCommentChangeResult.
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#changedClassName -> #Object.
		#status -> 'changed'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLClassCommentChangeResultExamples >> classCommentChangeResultWithNilOldComment [
	<gtExample>
	<return: #GtLClassCommentChangeResult>
	| result compositeView dataBlock jsonData expectedJson |
	
	result := GtLClassCommentChangeResult new
		updatedClass: Object;
		status: 'changed';
		oldClassComment: nil;
		newClassComment: 'First comment'.
	self assert: result oldClassComment isNil.
	self assert: result newClassComment equals: 'First comment'.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#changedClassName -> #Object.
		#status -> 'changed'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ result
]

{ #category : #examples }
GtLClassCommentChangeResultExamples >> emptyClassCommentChangeResult [
	<gtExample>
	<return: #GtLClassCommentChangeResult>
	| result compositeView dataBlock jsonData expectedJson |
	
	result := GtLClassCommentChangeResult new
		updatedClass: Object;
		status: 'changed';
		oldClassComment: '';
		newClassComment: 'A new comment'.
	self assert: result oldClassComment equals: ''.
	self assert: result newClassComment equals: 'A new comment'.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#changedClassName -> #Object.
		#status -> 'changed'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ result
]

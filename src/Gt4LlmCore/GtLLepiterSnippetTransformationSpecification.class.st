Class {
	#name : #GtLLepiterSnippetTransformationSpecification,
	#superclass : #GtLLepiterTransformationSpecification,
	#instVars : [
		'pageUidString'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLLepiterSnippetTransformationSpecification >> pageUid [
	^ UUID gtFromString: self pageUidString 
]

{ #category : #accessing }
GtLLepiterSnippetTransformationSpecification >> pageUidString [
	^ pageUidString
]

{ #category : #accessing }
GtLLepiterSnippetTransformationSpecification >> pageUidString: anObject [
	pageUidString := anObject
]

{ #category : #descriptions }
GtLLepiterSnippetTransformationSpecification >> pageUidStringDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		  accessor: #pageUidString;
		  withUUIDFormatCommentWith: 'The uid of the page containing the snippet to edit.';
		  beRequired
]

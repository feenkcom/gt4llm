"
Examples for GtSimpleInMemoryVectorDatabase.
"
Class {
	#name : #GtSimpleInMemoryVectorDatabaseExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-VectorDb-Examples'
}

{ #category : #examples }
GtSimpleInMemoryVectorDatabaseExamples >> queryReturnsHighestMatch [
	<gtExample>
	<noTest>
	| database matches |
	database := GtSimpleInMemoryVectorDatabase new.
	database addDocument: 'Our refund policy lasts 30 days.' key: #refunds.
	database addDocument: 'You can change your password from account settings.' key: #password.
	database addDocument: 'Shipping usually takes 5 to 7 business days.' key: #shipping.
	matches := database query: 'How long does delivery take?' maxMatches: 2.
	self assert: matches first embedding key equals: #shipping.
	^ matches
]

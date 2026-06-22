Class {
	#name : #GtLDataSourceResponseParser,
	#superclass : #GtLDataSourceParser,
	#category : #'Gt4Llm-DataSource-Parser'
}

{ #category : #api }
GtLDataSourceResponseParser >> parseResponse: requestResponse at: index for: aMessageConstructor [

	self subclassResponsibility
]

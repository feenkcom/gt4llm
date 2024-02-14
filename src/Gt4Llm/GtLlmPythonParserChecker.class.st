Class {
	#name : #GtLlmPythonParserChecker,
	#superclass : #GtLlmSmaCCParserChecker,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmPythonParserChecker class >> language [
	^ 'Python'
]

{ #category : #accessing }
GtLlmPythonParserChecker class >> parserClass [
	^ PythonParser
]

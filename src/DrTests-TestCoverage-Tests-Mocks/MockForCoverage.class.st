"
A mock class with methods used for testing the coverage plugin of DrTest
"
Class {
	#name : #MockForCoverage,
	#superclass : #Object,
	#category : #'DrTests-TestCoverage-Tests-Mocks-Mocking'
}

{ #category : #'sample methods' }
MockForCoverage >> method1ForMock [

	^ 1 + 1
]

{ #category : #'sample methods' }
MockForCoverage >> method2ForMock: anObject [

	^ 1 + anObject
]

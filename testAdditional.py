"""
Each file that starts with test... in this directory is scanned for subclasses of unittest.TestCase or testLib.RestTestCase
"""

import unittest
import os
import testLib



class TestAddingEmptyUsername(testLib.RestTestCase):
	"""Testing adding an empty username"""
	def assertResponse(self, respData, count = 0, errCode = testLib.RestTestCase.ERR_BAD_USERNAME):
		expected = {'errorCode': errCode}
		if count is not None:
			expected['count'] = count
		self.assertDictEqual(expected, respData)

	def testEmptyUser(self):
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : '', 'password' : 'password'} )
		self.assertResponse(respData, respData['count'])
		
class TestAddingLongPassword(testLib.RestTestCase):
	"""Testing too long of a password"""
	def assertResponse(self, respData, count = 0, errCode = testLib.RestTestCase.ERR_BAD_PASSWORD):
		expected = {'errorCode': errCode}
		if count is not None:
			expected['count'] = count
		self.assertDictEqual(expected, respData)

	def testLongPass(self):
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'kiyana', 'password' : 'password'*100} )
		self.assertResponse(respData, respData['count'])
		
class TestAddingLongUsername(testLib.RestTestCase):
	"""Testing too long of a username"""
	def assertResponse(self, respData, count = 0, errCode = testLib.RestTestCase.ERR_BAD_USERNAME):
		expected = {'errorCode': errCode}
		if count is not None:
			expected['count'] = count
		self.assertDictEqual(expected, respData)

	def testLongUser(self):
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'kiyana'*100, 'password' : 'password'} )
		self.assertResponse(respData, respData['count'])	

class TestLoginValidUserBadPass(testLib.RestTestCase):
	"""Testing logging in with a valid username and invalid password"""
	def assertResponse(self, respData, count = 0, errCode = testLib.RestTestCase.ERR_BAD_CREDENTIALS):
		expected = {'errorCode': errCode}
		if count is not None:
			expected['count'] = count
		self.assertDictEqual(expected, respData)

	def testValidUserBadPass(self):
		self.makeRequest("/users/add", method="POST", data = { 'user' : 'kiyana', 'password' : 'password'} )
		respData = 	self.makeRequest("/users/login", method="POST", data = { 'user' : 'kiyana', 'password' : 'passworddddd'} )
		self.assertResponse(respData, respData['count'])

class TestLoginINValidUserGoodPass(testLib.RestTestCase):
	"""Testing logging in with a invalid username and valid password"""
	def assertResponse(self, respData, count = 0, errCode = testLib.RestTestCase.ERR_BAD_CREDENTIALS):
		expected = {'errorCode': errCode}
		if count is not None:
			expected['count'] = count
		self.assertDictEqual(expected, respData)

	def testInValidUserGoodPass(self):
		self.makeRequest("/users/add", method="POST", data = { 'user' : 'kiyana', 'password' : 'password'} )
		respData = 	self.makeRequest("/users/login", method="POST", data = { 'user' : 'kiyanaaaaaa', 'password' : 'password'} )
		self.assertResponse(respData, respData['count'])	

class TestCountIncrement(testLib.RestTestCase):
	"""Testing whether count is being incremented upon multiple logins"""
	def assertResponse(self, respData, count = 0, errCode = testLib.RestTestCase.SUCCESS):
		expected = {'errorCode': errCode}
		if count is not None:
			expected['count'] = 2
		self.assertDictEqual(expected, respData)

	def testIncrement(self):
		self.makeRequest("/users/add", method="POST", data = { 'user' : 'kiyana', 'password' : 'password'} )
		respData = 	self.makeRequest("/users/login", method="POST", data = { 'user' : 'kiyana', 'password' : 'password'} )
		self.assertResponse(respData, respData['count'])		

		
			
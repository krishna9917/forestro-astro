// @ts-check

import axios from "axios";

/**
 * @typedef {Object} RequestOptions
 * @property {string} method - HTTP method (GET, POST, PUT, DELETE, etc.)
 * @property {string} url - The URL to which the request is made
 * @property {Object} [data] - Data to be sent as the request body
 * @property {string} [token] - Authorization token
 */

/**
 * @typedef {Object} ApiResponse
 * @property {*} data - Response data
 * @property {number} status - HTTP status code
 * @property {Object} headers - Response headers
 */

/**
 * Makes an HTTP request using Axios.
 * @param {RequestOptions} options - Request options
 * @returns {Promise<ApiResponse>} - Promise resolving to the response
 */
export const request = async ({ method, url, data, token }) => {
  try {
    const response = await axios.request({
      baseURL: "https://foreastro.com/api",
//      baseURL: "https://foreastro.com/api",
      url,
      method,
      data,
      headers: { Authorization: "Bearer " + token },
    });

    return response;
  } catch (error) {
    throw error;
  }
};

/**
 * Converts JSON data to FormData object.
 * @param {Object} jsonData - JSON data to convert
 * @returns {FormData} - FormData object with JSON data converted
 */
export const jsonToFormData = (jsonData) => {
  const formData = new FormData();
  // Iterate over each key-value pair in the JSON data
  Object.entries(jsonData).forEach(([key, value]) => {
    // If the value is an object or array, stringify it
    if (typeof value === "object" && value !== null) {
      value = JSON.stringify(value);
    }
    // Append key-value pair to FormData object
    formData.append(key, value);
  });
  return formData;
};

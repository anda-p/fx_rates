class RatesDataSource
    def base_currency
        raise NotImplementedError "Method should be implemented"
    end

    def load_data
        raise NotImplementedError "Method should be implemented"
    end    
end 